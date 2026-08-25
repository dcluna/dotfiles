# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require_relative "../cops/no_direct_record_mutation"

RSpec.describe CustomCops::NoDirectRecordMutation do
  include RuboCop::RSpec::ExpectOffense

  let(:config) do
    RuboCop::Config.new(
      "CustomCops/NoDirectRecordMutation" => {
        "AllowedReceivers" => %w[config]
      }
    )
  end

  subject(:cop) { described_class.new(config) }

  context "flags direct mutations" do
    it "flags update_columns" do
      expect_offense(<<~RUBY)
        fee_course.update_columns(kind: :athletic_reg)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `update_columns` in specs — mutate records through GraphQL helpers. See spec/support/graphql_helpers/README.md
      RUBY
    end

    it "flags update!" do
      expect_offense(<<~RUBY)
        enrollment.update!(status: :active)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `update!` in specs — mutate records through GraphQL helpers. See spec/support/graphql_helpers/README.md
      RUBY
    end

    it "flags update" do
      expect_offense(<<~RUBY)
        record.update(name: "foo")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `update` in specs — mutate records through GraphQL helpers. See spec/support/graphql_helpers/README.md
      RUBY
    end

    it "flags chained receiver" do
      expect_offense(<<~RUBY)
        Enrollment.find(1).update_columns(status: :paid)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `update_columns` in specs — mutate records through GraphQL helpers. See spec/support/graphql_helpers/README.md
      RUBY
    end
  end

  context "allowed cases" do
    it "allows configured receiver" do
      expect_no_offenses(<<~RUBY)
        config.update(key: "value")
      RUBY
    end

    it "ignores bare update (no receiver)" do
      expect_no_offenses(<<~RUBY)
        update(name: "test")
      RUBY
    end
  end
end
