# frozen_string_literal: true

module CustomCops
  # Ensures that `initialize` only performs direct ivar assignments from parameters.
  # Complex expressions (conditionals, method calls, defaults) should be moved
  # to memoized methods.
  #
  # @example Bad
  #   def initialize(parent_defaults, domain_model_id)
  #     @parent_defaults = parent_defaults || {}
  #     @domain_model = domain_model_id.present? ? DomainModel.find(domain_model_id) : nil
  #   end
  #
  # @example Good
  #   def initialize(parent_defaults, domain_model_id)
  #     @parent_defaults = parent_defaults
  #     @domain_model_id = domain_model_id
  #   end
  #
  #   def parent_defaults
  #     @parent_defaults ||= {}
  #   end
  #
  #   def domain_model
  #     @domain_model ||= domain_model_id.present? ? DomainModel.find(domain_model_id) : nil
  #   end
  class NoComplexInitializeAssignment < RuboCop::Cop::Base
    MSG = "Avoid complex expressions in initialize ivar assignments. " \
          "Use direct assignment (`@foo = foo`) and move logic to memoized methods."

    ALLOWED_RHS_TYPES = %i[
      nil
      true
      false
      int
      float
      str
      sym
    ].freeze

    def on_def(node)
      return unless node.method_name == :initialize

      # Collect parameter names for validation
      param_names = extract_param_names(node)

      node.body&.each_node(:ivasgn) do |ivasgn|
        # Only check direct children of the method body (or begin block)
        next unless direct_child_of_body?(node.body, ivasgn)

        rhs = ivasgn.children[1]
        next if rhs.nil? # bare @foo with no assignment

        next if allowed_rhs?(rhs, param_names)

        add_offense(ivasgn)
      end
    end

    private

    def extract_param_names(def_node)
      def_node.arguments.flat_map do |arg|
        case arg.type
        when :arg, :optarg, :kwarg, :kwoptarg
          [arg.children[0]]
        when :restarg, :kwrestarg
          arg.children[0] ? [arg.children[0]] : []
        else
          []
        end
      end
    end

    def direct_child_of_body?(body, node)
      if body.begin_type?
        body.children.include?(node)
      else
        body == node
      end
    end

    def allowed_rhs?(rhs, param_names)
      # Simple literal types
      return true if ALLOWED_RHS_TYPES.include?(rhs.type)

      # Local variable reference (ideally matching a parameter)
      if rhs.type == :lvar
        return true if param_names.include?(rhs.children[0])
      end

      false
    end
  end
end
