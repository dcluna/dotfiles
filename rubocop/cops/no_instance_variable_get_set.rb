# frozen_string_literal: true

module CustomCops
  # Flags usage of `instance_variable_get` and `instance_variable_set`.
  #
  # These methods bypass encapsulation and are often used to work around
  # cops like `NoIvarOutsideEntryMethod`. Prefer proper accessors or
  # constructor injection instead.
  #
  # @example Bad
  #   instance_variable_get(:@foo)
  #   obj.instance_variable_set(:@bar, value)
  #
  # @example Good — accessor
  #   attr_reader :foo
  #   foo
  #
  # @example Good — constructor injection
  #   def initialize(bar)
  #     @bar = bar
  #   end
  class NoInstanceVariableGetSet < RuboCop::Cop::Base
    MSG = "Do not use `%<method>s`. Use proper accessors or constructor injection instead."

    RESTRICT_ON_SEND = %i[instance_variable_get instance_variable_set].freeze

    def on_send(node)
      add_offense(node, message: format(MSG, method: node.method_name))
    end
  end
end
