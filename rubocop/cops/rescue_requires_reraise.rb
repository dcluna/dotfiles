# frozen_string_literal: true

module CustomCops
  # Enforces that every `rescue` block contains a conditional re-raise guard.
  #
  # The required guard expression is configurable via `RaiseGuard`.
  # Default: `TestOnlyBehavior.raise_errors?`
  #
  # @example Bad
  #   begin
  #     do_work
  #   rescue => e
  #     log(e)
  #   end
  #
  # @example Good
  #   begin
  #     do_work
  #   rescue => e
  #     raise if TestOnlyBehavior.raise_errors?
  #     log(e)
  #   end
  class RescueRequiresReraise < RuboCop::Cop::Base
    MSG = "Rescue blocks must include `raise if %<guard>s`."

    def on_resbody(node)
      guard = raise_guard
      body = node.body
      return add_guard_offense(node) unless body

      # Body can be a single node or a begin (compound) node
      statements = body.begin_type? ? body.children : [body]
      return unless statements.none? { |stmt| raise_if_guard?(stmt, guard) }

      add_guard_offense(node)
    end

    private

    def raise_if_guard?(node, guard)
      # Match: raise if <guard>
      return false unless node.type == :if
      return false unless node.modifier_form?

      condition = node.condition
      body_expr = node.if_branch

      body_expr&.type == :send &&
        body_expr.method_name == :raise &&
        body_expr.arguments.empty? &&
        condition.source == guard
    end

    def raise_guard
      cop_config["RaiseGuard"] || "TestOnlyBehavior.raise_errors?"
    end

    def add_guard_offense(node)
      add_offense(node, message: format(MSG, guard: raise_guard))
    end
  end
end
