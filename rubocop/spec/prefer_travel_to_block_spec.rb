# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require_relative "../cops/prefer_travel_to_block"

RSpec.describe CustomCops::PreferTravelToBlock do
  include RuboCop::RSpec::ExpectOffense

  let(:config) do
    RuboCop::Config.new("CustomCops/PreferTravelToBlock" => {})
  end

  subject(:cop) { described_class.new(config) }

  context "when travel_to is used without a block and travel_back follows" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1))
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the block form of `travel_to` instead of calling `travel_to` and `travel_back` separately.
        do_something
        travel_back
      RUBY

      expect_correction(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1)) do
          do_something
        end
      RUBY
    end
  end

  context "when travel_to already uses block form" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1)) do
          do_something
        end
      RUBY
    end
  end

  context "when travel_to has no matching travel_back" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1))
        do_something
      RUBY
    end
  end

  context "when multiple statements exist between travel_to and travel_back" do
    it "wraps all statements in the block" do
      expect_offense(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1))
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the block form of `travel_to` instead of calling `travel_to` and `travel_back` separately.
        first_thing
        second_thing
        third_thing
        travel_back
      RUBY

      expect_correction(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1)) do
          first_thing
          second_thing
          third_thing
        end
      RUBY
    end
  end

  context "when travel_to and travel_back are inside a method def" do
    it "registers an offense and corrects" do
      expect_offense(<<~RUBY)
        def test_something
          travel_to(Time.zone.local(2024, 1, 1))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the block form of `travel_to` instead of calling `travel_to` and `travel_back` separately.
          do_something
          travel_back
        end
      RUBY

      expect_correction(<<~RUBY)
        def test_something
          travel_to(Time.zone.local(2024, 1, 1)) do
            do_something
          end
        end
      RUBY
    end
  end

  context "when travel_to and travel_back are inside a block" do
    it "registers an offense and corrects" do
      expect_offense(<<~RUBY)
        it "does something" do
          travel_to(Time.zone.local(2024, 1, 1))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the block form of `travel_to` instead of calling `travel_to` and `travel_back` separately.
          do_something
          travel_back
        end
      RUBY

      expect_correction(<<~RUBY)
        it "does something" do
          travel_to(Time.zone.local(2024, 1, 1)) do
            do_something
          end
        end
      RUBY
    end
  end

  context "when there are no statements between travel_to and travel_back" do
    it "registers an offense and creates empty block" do
      expect_offense(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1))
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the block form of `travel_to` instead of calling `travel_to` and `travel_back` separately.
        travel_back
      RUBY

      expect_correction(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1)) do
        end
      RUBY
    end
  end

  context "when travel_to uses curly brace block form" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1)) { do_something }
      RUBY
    end
  end

  context "when travel_to has a second argument (with_usec)" do
    it "registers an offense and preserves args" do
      expect_offense(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1), with_usec: true)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the block form of `travel_to` instead of calling `travel_to` and `travel_back` separately.
        do_something
        travel_back
      RUBY

      expect_correction(<<~RUBY)
        travel_to(Time.zone.local(2024, 1, 1), with_usec: true) do
          do_something
        end
      RUBY
    end
  end
end
