# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require_relative "../cops/prefer_with_versioning"

RSpec.describe CustomCops::PreferWithVersioning do
  include RuboCop::RSpec::ExpectOffense

  let(:config) do
    RuboCop::Config.new("CustomCops/PreferWithVersioning" => {})
  end

  subject(:cop) { described_class.new(config) }

  context "when PaperTrail.enabled is set to true" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        PaperTrail.enabled = true
        ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `with_versioning` block instead of manually setting `PaperTrail.enabled=`. See https://github.com/paper-trail-gem/paper_trail?tab=readme-ov-file#7b-rspec
      RUBY
    end
  end

  context "when PaperTrail.enabled is set to false" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        PaperTrail.enabled = false
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `with_versioning` block instead of manually setting `PaperTrail.enabled=`. See https://github.com/paper-trail-gem/paper_trail?tab=readme-ov-file#7b-rspec
      RUBY
    end
  end

  context "when PaperTrail.enabled is toggled around code" do
    it "registers offenses on both assignments" do
      expect_offense(<<~RUBY)
        PaperTrail.enabled = true
        ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `with_versioning` block instead of manually setting `PaperTrail.enabled=`. See https://github.com/paper-trail-gem/paper_trail?tab=readme-ov-file#7b-rspec
        do_something
        PaperTrail.enabled = false
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `with_versioning` block instead of manually setting `PaperTrail.enabled=`. See https://github.com/paper-trail-gem/paper_trail?tab=readme-ov-file#7b-rspec
      RUBY
    end
  end

  context "when PaperTrail.enabled is set inside a spec block" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        it "does something" do
          PaperTrail.enabled = true
          ^^^^^^^^^^^^^^^^^^^^^^^^^ Use `with_versioning` block instead of manually setting `PaperTrail.enabled=`. See https://github.com/paper-trail-gem/paper_trail?tab=readme-ov-file#7b-rspec
          do_something
        end
      RUBY
    end
  end

  context "when with_versioning block is used" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        with_versioning do
          do_something
        end
      RUBY
    end
  end

  context "when PaperTrail is used for something else" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        PaperTrail.request.whodunnit = user.id
      RUBY
    end
  end

  context "when a variable named enabled is set on something else" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        SomethingElse.enabled = true
      RUBY
    end
  end
end
