# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require_relative "../cops/no_ivar_outside_entry_method"

RSpec.describe CustomCops::NoIvarOutsideEntryMethod do
  include RuboCop::RSpec::ExpectOffense

  let(:cop_config) do
    { "EntryMethods" => entry_methods }
  end
  let(:entry_methods) { ["initialize"] }
  let(:config) do
    RuboCop::Config.new("CustomCops/NoIvarOutsideEntryMethod" => cop_config)
  end

  subject(:cop) { described_class.new(config) }

  context "when ivars are inside initialize" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def initialize(bar)
            @bar = bar
          end
        end
      RUBY
    end
  end

  context "when ivars are read outside initialize" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        class Foo
          def initialize(bar)
            @bar = bar
          end

          def do_work
            @bar.process
            ^^^^ Use reader/accessor methods instead of instance variables outside initialize. Memoization patterns (`def foo; @foo ||= ...; end`) are allowed.
          end
        end
      RUBY
    end
  end

  context "when ivars are assigned outside initialize" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        class Foo
          def initialize(bar)
            @bar = bar
          end

          def reset
            @bar = nil
            ^^^^^^^^^^ Use reader/accessor methods instead of instance variables outside initialize. Memoization patterns (`def foo; @foo ||= ...; end`) are allowed.
          end
        end
      RUBY
    end
  end

  context "when using memoization pattern" do
    it "allows @foo inside def foo" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def initialize(id)
            @id = id
          end

          def computed_result
            @computed_result ||= expensive_calculation
          end
        end
      RUBY
    end

    it "allows @foo read inside def foo" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def cached_value
            @cached_value
          end
        end
      RUBY
    end
  end

  context "when ivar name does not match method name" do
    it "flags @bar inside def foo" do
      expect_offense(<<~RUBY)
        class Foo
          def initialize(bar)
            @bar = bar
          end

          def foo
            @bar
            ^^^^ Use reader/accessor methods instead of instance variables outside initialize. Memoization patterns (`def foo; @foo ||= ...; end`) are allowed.
          end
        end
      RUBY
    end
  end

  context "when ivars are in class body (outside any method)" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        class Foo
          @class_ivar = 1
          ^^^^^^^^^^^^^^^ Use reader/accessor methods instead of instance variables outside initialize. Memoization patterns (`def foo; @foo ||= ...; end`) are allowed.
        end
      RUBY
    end
  end

  context "when EntryMethods includes perform" do
    let(:entry_methods) { ["initialize", "perform"] }

    it "allows ivars inside perform" do
      expect_no_offenses(<<~RUBY)
        class MyWorker
          def perform(user_id)
            @user_id = user_id
          end
        end
      RUBY
    end

    it "flags ivars outside both initialize and perform" do
      expect_offense(<<~RUBY)
        class MyWorker
          def perform(user_id)
            @user_id = user_id
          end

          def helper
            @user_id
            ^^^^^^^^ Use reader/accessor methods instead of instance variables outside initialize/perform. Memoization patterns (`def foo; @foo ||= ...; end`) are allowed.
          end
        end
      RUBY
    end

    it "still allows memoization but flags non-matching ivars inside it" do
      expect_offense(<<~RUBY)
        class MyWorker
          def perform(user_id)
            @user_id = user_id
          end

          def user
            @user ||= User.find(@user_id)
                                ^^^^^^^^ Use reader/accessor methods instead of instance variables outside initialize/perform. Memoization patterns (`def foo; @foo ||= ...; end`) are allowed.
          end
        end
      RUBY
    end

    it "allows pure memoization" do
      expect_no_offenses(<<~RUBY)
        class MyWorker
          def perform(user_id)
            @user_id = user_id
          end

          def user
            @user ||= User.find(user_id)
          end
        end
      RUBY
    end
  end

  context "when memoization has multiple ivars" do
    it "allows matching ivar but flags non-matching" do
      expect_offense(<<~RUBY)
        class Foo
          def initialize(id)
            @id = id
          end

          def user
            @user ||= User.find(@id)
                                ^^^ Use reader/accessor methods instead of instance variables outside initialize. Memoization patterns (`def foo; @foo ||= ...; end`) are allowed.
          end
        end
      RUBY
    end
  end

  context "with default config (initialize only)" do
    it "flags ivars in perform" do
      expect_offense(<<~RUBY)
        class MyWorker
          def perform(user_id)
            @user_id = user_id
            ^^^^^^^^^^^^^^^^^^ Use reader/accessor methods instead of instance variables outside initialize. Memoization patterns (`def foo; @foo ||= ...; end`) are allowed.
          end
        end
      RUBY
    end
  end
end
