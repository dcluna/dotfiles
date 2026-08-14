# frozen_string_literal: true

module CustomCops
  # Flags `create(:factory)` calls in specs for domain objects that should
  # be set up via GraphQL helpers instead of FactoryBot.
  #
  # Factories bypass business logic and create data that may be inconsistent.
  # GraphQL helpers exercise the same code paths users take.
  #
  # Configure `AllowedFactories` in .rubocop.yml to permit factories that
  # have no GraphQL helper equivalent (e.g. seed-only records).
  #
  # @example Bad
  #   let(:order) { create(:order, :paid) }
  #
  # @example Good (GraphQL helper)
  #   let(:order) do
  #     parent.add_to_cart(course: course, student: student)
  #     parent.checkout(payment_method: "pm_card_visa")
  #   end
  #
  # @example Good (allowed factory)
  #   let(:auth) { create(:domain_auth) }
  #
  class NoDirectFactoryCreate < RuboCop::Cop::Base
    MSG = "Use GraphQL helpers instead of `create(:%<factory>s)`. " \
      "See spec/support/graphql_helpers/README.md"

    RESTRICT_ON_SEND = [:create].freeze

    def on_send(node)
      return unless factory_create?(node)

      factory_name = node.first_argument.value
      return if allowed?(factory_name)

      add_offense(node, message: format(MSG, factory: factory_name))
    end

    private

    def factory_create?(node)
      return false unless node.method?(:create)
      return false if node.receiver # skip SomeClass.create
      return false if node.arguments.empty?

      node.first_argument.sym_type?
    end

    def allowed?(factory_name)
      allowed_factories.include?(factory_name.to_s)
    end

    def allowed_factories
      cop_config.fetch("AllowedFactories", [])
    end
  end
end
