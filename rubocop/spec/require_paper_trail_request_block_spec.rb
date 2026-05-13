# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require_relative "../cops/require_paper_trail_request_block"

RSpec.describe CustomCops::RequirePaperTrailRequestBlock do
  include RuboCop::RSpec::ExpectOffense

  let(:config) do
    RuboCop::Config.new("CustomCops/RequirePaperTrailRequestBlock" => {})
  end

  subject(:cop) { described_class.new(config) }

  context "when setting whodunnit via property assignment" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        PaperTrail.request.whodunnit = "Worker"
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the block form of `PaperTrail.request` instead of setting properties directly.
      RUBY
    end
  end

  context "when setting enabled via property assignment" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        PaperTrail.request.enabled = false
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the block form of `PaperTrail.request` instead of setting properties directly.
      RUBY
    end
  end

  context "when setting controller_info via property assignment" do
    it "registers an offense" do
      expect_offense(<<~RUBY)
        PaperTrail.request.controller_info = { ip: "1.2.3.4" }
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use the block form of `PaperTrail.request` instead of setting properties directly.
      RUBY
    end
  end
end
