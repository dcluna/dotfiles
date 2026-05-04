# frozen_string_literal: true

module CustomCops
  # Enforces using the block form of `travel_to` instead of manually
  # calling `travel_to` and `travel_back`.
  #
  # The block form automatically calls `travel_back` when the block exits,
  # which is safer and more readable.
  #
  # @example Bad
  #   travel_to(Time.zone.local(2024, 1, 1))
  #   do_something
  #   travel_back
  #
  # @example Good
  #   travel_to(Time.zone.local(2024, 1, 1)) do
  #     do_something
  #   end
  #
  class PreferTravelToBlock < RuboCop::Cop::Base
    extend RuboCop::Cop::AutoCorrector

    MSG = "Use the block form of `travel_to` instead of calling `travel_to` and `travel_back` separately."

    RESTRICT_ON_SEND = [:travel_to].freeze

    # @!method travel_to_without_block?(node)
    def_node_matcher :travel_to_without_block?, <<~PATTERN
      (send nil? :travel_to _ ...)
    PATTERN

    def on_send(node)
      return unless travel_to_without_block?(node)
      return if node.parent&.block_type? || node.block_literal?

      travel_back_node = find_travel_back(node)
      return unless travel_back_node

      add_offense(node) do |corrector|
        autocorrect(corrector, node, travel_back_node)
      end
    end

    private

    def find_travel_back(travel_to_node)
      siblings = sibling_statements(travel_to_node)
      return nil unless siblings

      travel_to_idx = siblings.index(travel_to_node)
      return nil unless travel_to_idx

      siblings[(travel_to_idx + 1)..].detect do |sibling|
        sibling.send_type? && sibling.method?(:travel_back)
      end
    end

    def sibling_statements(node)
      parent = node.parent
      return nil unless parent

      if parent.begin_type? || parent.kwbegin_type?
        parent.children
      elsif parent.block_type? && parent.body
        if parent.body.begin_type?
          parent.body.children
        else
          [parent.body]
        end
      elsif parent.def_type? && parent.body
        if parent.body.begin_type?
          parent.body.children
        else
          [parent.body]
        end
      end
    end

    def autocorrect(corrector, travel_to_node, travel_back_node)
      siblings = sibling_statements(travel_to_node)
      travel_to_idx = siblings.index(travel_to_node)
      travel_back_idx = siblings.index(travel_back_node)

      inner_nodes = siblings[(travel_to_idx + 1)...travel_back_idx]

      indent = " " * travel_to_node.loc.column

      # Append " do" to travel_to
      corrector.insert_after(travel_to_node, " do")

      # Indent inner statements by 2 extra spaces
      inner_nodes.each do |inner|
        corrector.insert_before(inner, "  ")
      end

      # Replace travel_back with end (preserves surrounding whitespace/newlines)
      corrector.replace(travel_back_node, "end")
    end
  end
end
