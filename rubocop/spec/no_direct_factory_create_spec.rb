# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/expect_offense"
require "rubocop/rspec/support"
require_relative "../cops/no_direct_factory_create"

RSpec.describe CustomCops::NoDirectFactoryCreate do
  include RuboCop::RSpec::ExpectOffense

  let(:config) do
    RuboCop::Config.new(
      "CustomCops/NoDirectFactoryCreate" => {
        "AllowedFactories" => %w[domain_auth admin_user]
      }
    )
  end

  subject(:cop) { described_class.new(config) }

  context "disallowed factory calls" do
    it "registers an offense for create(:order)" do
      expect_offense(<<~RUBY)
        let(:order) { create(:order, :paid) }
                      ^^^^^^^^^^^^^^^^^^^^^ Use GraphQL helpers instead of `create(:order)`. See spec/support/graphql_helpers/README.md
      RUBY
    end

    it "registers an offense for create(:enrollment)" do
      expect_offense(<<~RUBY)
        let(:enrollment) { create(:enrollment) }
                           ^^^^^^^^^^^^^^^^^^^ Use GraphQL helpers instead of `create(:enrollment)`. See spec/support/graphql_helpers/README.md
      RUBY
    end

    it "registers an offense for create with traits and attributes" do
      expect_offense(<<~RUBY)
        let(:payment) { create(:payment, :completed, amount: 100) }
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use GraphQL helpers instead of `create(:payment)`. See spec/support/graphql_helpers/README.md
      RUBY
    end
  end

  context "allowed factory calls" do
    it "does not register offense for allowed factory" do
      expect_no_offenses(<<~RUBY)
        let(:auth) { create(:domain_auth) }
      RUBY
    end

    it "does not register offense for another allowed factory" do
      expect_no_offenses(<<~RUBY)
        let(:admin) { create(:admin_user, :superadmin) }
      RUBY
    end
  end

  context "non-factory create calls" do
    it "does not register offense for create with receiver" do
      expect_no_offenses(<<~RUBY)
        let(:record) { SomeModel.create(name: "test") }
      RUBY
    end

    it "does not register offense for create with string arg" do
      expect_no_offenses(<<~RUBY)
        let(:file) { create("some_path") }
      RUBY
    end

    it "does not register offense for create with no args" do
      expect_no_offenses(<<~RUBY)
        record.create
      RUBY
    end
  end
end
