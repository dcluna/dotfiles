# frozen_string_literal: true

module CustomCops
  # Enforces using the block form of `PaperTrail.request` instead of
  # setting properties directly or calling it with keyword arguments
  # without a block.
  #
  # The block form scopes configuration changes, preventing state leaks
  # across Sidekiq jobs or request boundaries.
  #
  # @example Bad — property assignment
  #   PaperTrail.request.whodunnit = "Worker"
  #   PaperTrail.request.enabled = false
  #
  # @example Bad — kwargs without block
  #   PaperTrail.request(whodunnit: "Worker")
  #
  # @example Good — block form
  #   PaperTrail.request(whodunnit: "Worker") do
  #     do_work
  #   end
  class RequirePaperTrailRequestBlock < RuboCop::Cop::Base
    MSG_PROPERTY = "Use the block form of `PaperTrail.request` instead of setting properties directly."
    MSG_NO_BLOCK = "Use the block form of `PaperTrail.request` instead of the non-block form."

    RESTRICT_ON_SEND = [:request].freeze

    def on_send(node)
      check_property_assignment(node)
      check_kwargs_without_block(node)
    end

    private

    def check_property_assignment(node)
      return unless paper_trail_request?(node)

      parent = node.parent
      return unless parent&.send_type?
      return unless parent.method_name.to_s.end_with?("=")

      add_offense(parent, message: MSG_PROPERTY)
    end

    def check_kwargs_without_block(node)
      return unless paper_trail_request?(node)
      return unless node.arguments?
      return if node.parent&.block_type? && node.parent.send_node == node
      return if node.block_literal?

      add_offense(node, message: MSG_NO_BLOCK)
    end

    def paper_trail_request?(node)
      return false unless node.method?(:request)

      receiver = node.receiver
      receiver&.const_type? && receiver.short_name == :PaperTrail
    end
  end
end
