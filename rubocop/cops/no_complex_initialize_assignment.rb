# frozen_string_literal: true

module CustomCops
  # Ensures that entry-point methods only perform direct ivar assignments from parameters.
  # Complex expressions (conditionals, method calls, defaults) should be moved
  # to memoized methods.
  #
  # Configurable via `Methods` (default: ['initialize']).
  # Set to ['initialize', 'perform'] for worker/job classes.
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
    MSG = "Avoid complex expressions in %<method>s ivar assignments. " \
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
      return unless target_methods.include?(node.method_name)

      param_names = extract_param_names(node)

      node.body&.each_node(:ivasgn) do |ivasgn|
        next unless direct_child_of_body?(node.body, ivasgn)

        rhs = ivasgn.children[1]
        next if rhs.nil?

        next if allowed_rhs?(rhs, param_names)

        add_offense(ivasgn, message: format(MSG, method: node.method_name))
      end
    end

    private

    def target_methods
      @target_methods ||= (cop_config["Methods"] || ["initialize"]).map(&:to_sym)
    end

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
