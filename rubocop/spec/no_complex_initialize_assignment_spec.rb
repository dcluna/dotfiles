# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require_relative "../cops/no_complex_initialize_assignment"

RSpec.describe CustomCops::NoComplexInitializeAssignment do
  include RuboCop::RSpec::ExpectOffense

  let(:cop_config) do
    { "Methods" => methods_list }
  end
  let(:methods_list) { ["initialize"] }
  let(:config) do
    RuboCop::Config.new("CustomCops/NoComplexInitializeAssignment" => cop_config)
  end

  subject(:cop) { described_class.new(config) }

  context "when initialize has direct parameter assignments" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def initialize(bar, baz)
            @bar = bar
            @baz = baz
          end
        end
      RUBY
    end
  end

  context "when initialize assigns nil/true/false/literals" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def initialize(bar)
            @bar = bar
            @ready = true
            @count = 0
            @name = "default"
            @flag = false
            @empty = nil
          end
        end
      RUBY
    end
  end

  context "when initialize has a conditional default" do
    it "registers an offense for || default" do
      expect_offense(<<~RUBY)
        class Foo
          def initialize(opts)
            @opts = opts || {}
            ^^^^^^^^^^^^^^^^^^ Avoid complex expressions in initialize ivar assignments. Use direct assignment (`@foo = foo`) and move logic to memoized methods.
          end
        end
      RUBY
    end
  end

  context "when initialize has a ternary" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        class Foo
          def initialize(id)
            @record = id.present? ? Record.find(id) : nil
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid complex expressions in initialize ivar assignments. Use direct assignment (`@foo = foo`) and move logic to memoized methods.
          end
        end
      RUBY
    end
  end

  context "when initialize has a method call" do
    it "registers an offense for finder call" do
      expect_offense(<<~RUBY)
        class Foo
          def initialize(id)
            @record = Record.find(id)
            ^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid complex expressions in initialize ivar assignments. Use direct assignment (`@foo = foo`) and move logic to memoized methods.
          end
        end
      RUBY
    end

    it "registers an offense for .new call" do
      expect_offense(<<~RUBY)
        class Foo
          def initialize(name)
            @logger = Logger.new(name)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid complex expressions in initialize ivar assignments. Use direct assignment (`@foo = foo`) and move logic to memoized methods.
          end
        end
      RUBY
    end
  end

  context "when initialize uses keyword args" do
    it "does not register an offense for direct assignment" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def initialize(bar:, baz: nil)
            @bar = bar
            @baz = baz
          end
        end
      RUBY
    end
  end

  context "when initialize uses splat args" do
    it "does not register an offense for direct assignment" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def initialize(*args, **kwargs)
            @args = args
            @kwargs = kwargs
          end
        end
      RUBY
    end
  end

  context "when complex assignment is in a non-initialize method" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def setup(id)
            @record = Record.find(id)
          end
        end
      RUBY
    end
  end

  context "when initialize has mixed valid and invalid assignments" do
    it "only flags the invalid ones" do
      expect_offense(<<~RUBY)
        class Foo
          def initialize(name, opts)
            @name = name
            @opts = opts || {}
            ^^^^^^^^^^^^^^^^^^ Avoid complex expressions in initialize ivar assignments. Use direct assignment (`@foo = foo`) and move logic to memoized methods.
          end
        end
      RUBY
    end
  end

  context "when assigning a local variable not from params" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        class Foo
          def initialize(name)
            computed = name.upcase
            @upper_name = computed
            ^^^^^^^^^^^^^^^^^^^^^^ Avoid complex expressions in initialize ivar assignments. Use direct assignment (`@foo = foo`) and move logic to memoized methods.
          end
        end
      RUBY
    end
  end

  context "when Methods includes perform" do
    let(:methods_list) { ["initialize", "perform"] }

    it "flags complex assignments in perform" do
      expect_offense(<<~RUBY)
        class MyWorker
          def perform(user_id)
            @user = User.find(user_id)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid complex expressions in perform ivar assignments. Use direct assignment (`@foo = foo`) and move logic to memoized methods.
          end
        end
      RUBY
    end

    it "allows direct assignments in perform" do
      expect_no_offenses(<<~RUBY)
        class MyWorker
          def perform(user_id)
            @user_id = user_id
          end
        end
      RUBY
    end

    it "still flags initialize too" do
      expect_offense(<<~RUBY)
        class MyWorker
          def initialize(opts)
            @opts = opts || {}
            ^^^^^^^^^^^^^^^^^^ Avoid complex expressions in initialize ivar assignments. Use direct assignment (`@foo = foo`) and move logic to memoized methods.
          end
        end
      RUBY
    end
  end

  context "when Methods is default (initialize only)" do
    it "does not flag perform" do
      expect_no_offenses(<<~RUBY)
        class MyWorker
          def perform(user_id)
            @user = User.find(user_id)
          end
        end
      RUBY
    end
  end
end
