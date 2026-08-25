# frozen_string_literal: true

module CustomCops
  # Flags `.update`, `.update!`, and `.update_columns` calls in specs.
  # These bypass the GraphQL layer and can hide bugs that only surface
  # in production where mutations go through the real code path.
  #
  # @example Bad
  #   fee_course.update_columns(kind: :athletic_reg)
  #   enrollment.update!(status: :active)
  #   record.update(name: "foo")
  #
  # @example Good
  #   Use GraphQL helpers to mutate records through the application layer.
  #
  class NoDirectRecordMutation < RuboCop::Cop::Base
    MSG = "Avoid `%<method>s` in specs — mutate records through GraphQL helpers. " \
      "See spec/support/graphql_helpers/README.md"

    RESTRICT_ON_SEND = %i[update update! update_columns].freeze

    def on_send(node)
      return unless node.receiver # bare `update` (no receiver) is unlikely to be AR
      return if allowed_receiver?(node)

      add_offense(node, message: format(MSG, method: node.method_name))
    end

    private

    def allowed_receiver?(node)
      receiver = node.receiver
      return false unless receiver.send_type? || receiver.lvar_type? || receiver.ivar_type?

      name = case receiver.type
             when :send then receiver.method_name.to_s
             when :lvar, :ivar then receiver.children.first.to_s
             end

      allowed_receivers.include?(name)
    end

    def allowed_receivers
      cop_config.fetch("AllowedReceivers", [])
    end
  end
end
