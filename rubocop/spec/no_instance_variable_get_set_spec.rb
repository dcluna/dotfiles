# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require_relative "../cops/no_instance_variable_get_set"

RSpec.describe CustomCops::NoInstanceVariableGetSet do
  include RuboCop::RSpec::ExpectOffense

  let(:config) do
    RuboCop::Config.new("CustomCops/NoInstanceVariableGetSet" => {})
  end

  subject(:cop) { described_class.new(config) }

  context "when using instance_variable_get" do
    it "registers an offense for bare call" do
      expect_offense(<<~RUBY)
        instance_variable_get(:@foo)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `instance_variable_get`. Use proper accessors or constructor injection instead.
      RUBY
    end

    it "registers an offense with explicit receiver" do
      expect_offense(<<~RUBY)
        obj.instance_variable_get(:@foo)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `instance_variable_get`. Use proper accessors or constructor injection instead.
      RUBY
    end

    it "registers an offense with string argument" do
      expect_offense(<<~RUBY)
        instance_variable_get("@foo")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `instance_variable_get`. Use proper accessors or constructor injection instead.
      RUBY
    end
  end

  context "when using instance_variable_set" do
    it "registers an offense for bare call" do
      expect_offense(<<~RUBY)
        instance_variable_set(:@foo, bar)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `instance_variable_set`. Use proper accessors or constructor injection instead.
      RUBY
    end

    it "registers an offense with explicit receiver" do
      expect_offense(<<~RUBY)
        obj.instance_variable_set(:@bar, value)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `instance_variable_set`. Use proper accessors or constructor injection instead.
      RUBY
    end
  end

  context "when using proper accessors" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        class Foo
          attr_reader :bar

          def initialize(bar)
            @bar = bar
          end

          def read_bar
            bar
          end
        end
      RUBY
    end
  end

  context "when using similarly named methods" do
    it "does not flag unrelated methods" do
      expect_no_offenses(<<~RUBY)
        get(:@foo)
        set(:@bar, value)
      RUBY
    end
  end
end
