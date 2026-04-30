# frozen_string_literal: true

module CustomCops
  # Flags instance variables used outside entry-point methods (initialize, perform).
  # Memoization patterns where `@foo` appears inside `def foo` are allowed.
  #
  # Configurable via `EntryMethods` (default: ['initialize']).
  #
  # @example Bad
  #   class Foo
  #     def initialize(bar)
  #       @bar = bar
  #     end
  #
  #     def do_work
  #       @bar.process  # should use accessor
  #     end
  #   end
  #
  # @example Good — accessor
  #   class Foo
  #     def initialize(bar)
  #       @bar = bar
  #     end
  #
  #     private
  #
  #     attr_reader :bar
  #
  #     def do_work
  #       bar.process
  #     end
  #   end
  #
  # @example Good — memoization
  #   class Foo
  #     def computed_result
  #       @computed_result ||= expensive_calculation
  #     end
  #   end
  class NoIvarOutsideEntryMethod < RuboCop::Cop::Base
    MSG = "Use reader/accessor methods instead of instance variables outside %<methods>s. " \
          "Memoization patterns (`def foo; @foo ||= ...; end`) are allowed."

    def on_ivar(node)
      check_ivar(node)
    end

    def on_ivasgn(node)
      check_ivar(node)
    end

    private

    def check_ivar(node)
      method_node = enclosing_method(node)

      # Ivars outside any method (class body) are flagged
      return add_ivar_offense(node) unless method_node

      method_name = method_node.method_name

      # Inside an entry method — always allowed
      return if entry_methods.include?(method_name)

      # Memoization pattern: @foo inside def foo
      return if memoization_pattern?(node, method_name)

      add_ivar_offense(node)
    end

    def enclosing_method(node)
      node.each_ancestor(:def).first
    end

    def memoization_pattern?(ivar_node, method_name)
      ivar_name = ivar_name_for(ivar_node)
      ivar_name == method_name
    end

    def ivar_name_for(node)
      # For both :ivar (@foo) and :ivasgn (@foo = ...), children[0] is the ivar name symbol
      name = node.children[0] # e.g. :@foo
      name.to_s.delete_prefix("@").to_sym
    end

    def entry_methods
      @entry_methods ||= (cop_config["EntryMethods"] || ["initialize"]).map(&:to_sym)
    end

    def add_ivar_offense(node)
      methods_str = entry_methods.join("/")
      add_offense(node, message: format(MSG, methods: methods_str))
    end
  end
end
