# frozen_string_literal: true

module CustomCops
  # Enforces using `with_versioning` block instead of manually toggling
  # `PaperTrail.enabled=` in specs.
  #
  # The `with_versioning` helper from paper_trail-rspec automatically
  # restores the previous state when the block exits, which is safer
  # and more readable.
  #
  # @see https://github.com/paper-trail-gem/paper_trail?tab=readme-ov-file#7b-rspec
  #
  # @example Bad
  #   PaperTrail.enabled = true
  #   do_something
  #   PaperTrail.enabled = false
  #
  # @example Bad
  #   PaperTrail.enabled = false
  #   do_something
  #
  # @example Good
  #   with_versioning do
  #     do_something
  #   end
  #
  class PreferWithVersioning < RuboCop::Cop::Base
    MSG = "Use `with_versioning` block instead of manually setting `PaperTrail.enabled=`. " \
          "See https://github.com/paper-trail-gem/paper_trail?tab=readme-ov-file#7b-rspec"

    # @!method paper_trail_enabled_assignment?(node)
    def_node_matcher :paper_trail_enabled_assignment?, <<~PATTERN
      (send (const nil? :PaperTrail) :enabled= _)
    PATTERN

    def on_send(node)
      return unless paper_trail_enabled_assignment?(node)

      add_offense(node)
    end
  end
end
