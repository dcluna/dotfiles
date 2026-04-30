# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require_relative "../cops/rescue_requires_reraise"

RSpec.describe CustomCops::RescueRequiresReraise do
  include RuboCop::RSpec::ExpectOffense

  let(:guard) { "TestOnlyBehavior.raise_errors?" }
  let(:cop_config) { { "RaiseGuard" => guard } }
  let(:config) do
    RuboCop::Config.new("CustomCops/RescueRequiresReraise" => cop_config)
  end

  subject(:cop) { described_class.new(config) }

  context "when rescue has the guard" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        begin
          do_work
        rescue => e
          raise if TestOnlyBehavior.raise_errors?
          log(e)
        end
      RUBY
    end
  end

  context "when rescue has the guard as only statement" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        begin
          do_work
        rescue => e
          raise if TestOnlyBehavior.raise_errors?
        end
      RUBY
    end
  end

  context "when rescue is missing the guard" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        begin
          do_work
        rescue => e
        ^^^^^^^^^^^ Rescue blocks must include `raise if TestOnlyBehavior.raise_errors?`.
          log(e)
        end
      RUBY
    end
  end

  context "when rescue body is empty" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        begin
          do_work
        rescue => e
        ^^^^^^^^^^^ Rescue blocks must include `raise if TestOnlyBehavior.raise_errors?`.
        end
      RUBY
    end
  end

  context "when rescue has raise without condition" do
    it "registers an offense (unconditional raise is not the guard)" do
      expect_offense(<<~RUBY)
        begin
          do_work
        rescue => e
        ^^^^^^^^^^^ Rescue blocks must include `raise if TestOnlyBehavior.raise_errors?`.
          raise
        end
      RUBY
    end
  end

  context "when rescue has raise with wrong guard" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        begin
          do_work
        rescue => e
        ^^^^^^^^^^^ Rescue blocks must include `raise if TestOnlyBehavior.raise_errors?`.
          raise if something_else?
        end
      RUBY
    end
  end

  context "when guard is not the first statement" do
    it "does not register an offense (guard present anywhere)" do
      expect_no_offenses(<<~RUBY)
        begin
          do_work
        rescue => e
          log(e)
          raise if TestOnlyBehavior.raise_errors?
        end
      RUBY
    end
  end

  context "inside a method def" do
    it "detects missing guard in method rescue" do
      expect_offense(<<~RUBY)
        def importing
          yield
        rescue => e
        ^^^^^^^^^^^ Rescue blocks must include `raise if TestOnlyBehavior.raise_errors?`.
          errors.push(e.message)
        end
      RUBY
    end

    it "allows guard in method rescue" do
      expect_no_offenses(<<~RUBY)
        def importing
          yield
        rescue => e
          raise if TestOnlyBehavior.raise_errors?
          errors.push(e.message)
        end
      RUBY
    end
  end

  context "with custom RaiseGuard config" do
    let(:guard) { "Rails.env.test?" }

    it "requires the custom guard" do
      expect_offense(<<~RUBY)
        begin
          do_work
        rescue => e
        ^^^^^^^^^^^ Rescue blocks must include `raise if Rails.env.test?`.
          log(e)
        end
      RUBY
    end

    it "accepts the custom guard" do
      expect_no_offenses(<<~RUBY)
        begin
          do_work
        rescue => e
          raise if Rails.env.test?
          log(e)
        end
      RUBY
    end
  end

  context "with multiple rescue clauses" do
    it "flags only the one missing the guard" do
      expect_offense(<<~RUBY)
        begin
          do_work
        rescue ActiveRecord::RecordNotFound => e
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Rescue blocks must include `raise if TestOnlyBehavior.raise_errors?`.
          nil
        rescue => e
          raise if TestOnlyBehavior.raise_errors?
          log(e)
        end
      RUBY
    end
  end

  context "with bare rescue (no exception variable)" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        begin
          do_work
        rescue
        ^^^^^^ Rescue blocks must include `raise if TestOnlyBehavior.raise_errors?`.
          retry
        end
      RUBY
    end
  end
end
