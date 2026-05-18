# frozen_string_literal: true

module CustomCops
  # Forbids `instance_double`, `create(:factory)`, and `build(:factory)`
  # calls inside RSpec example blocks (`it`, `specify`, `example`).
  #
  # These should be extracted to `let` or `let!` declarations so that
  # setup is separated from assertions and can be reused across examples.
  #
  # @example Bad
  #   it "does something" do
  #     user = create(:user)
  #     double = instance_double(User)
  #     obj = build(:widget)
  #   end
  #
  # @example Good
  #   let(:user) { create(:user) }
  #   let(:double) { instance_double(User) }
  #   let(:obj) { build(:widget) }
  #
  #   it "does something" do
  #     expect(user).to be_valid
  #   end
  #
  class NoSetupInExample < RuboCop::Cop::Base
    MSG_INSTANCE_DOUBLE = "Avoid `instance_double` inside example blocks. " \
      "Extract to a `let` or `let!` declaration instead."
    MSG_FACTORY = "Avoid `%<method>s` inside example blocks. " \
      "Extract to a `let` or `let!` declaration instead."

    EXAMPLE_METHODS = Set[:it, :specify, :example].freeze
    RESTRICT_ON_SEND = [:instance_double, :create, :build].freeze

    def on_send(node)
      return unless inside_example_block?(node)

      if node.method?(:instance_double)
        add_offense(node, message: MSG_INSTANCE_DOUBLE)
      elsif factory_call?(node)
        add_offense(node, message: format(MSG_FACTORY, method: node.method_name))
      end
    end

    private

    def inside_example_block?(node)
      node.each_ancestor(:block).any? do |block|
        block.method_name && EXAMPLE_METHODS.include?(block.method_name)
      end
    end

    def factory_call?(node)
      return false unless node.method?(:create) || node.method?(:build)
      return false if node.arguments.empty?

      node.first_argument.sym_type?
    end
  end
end
