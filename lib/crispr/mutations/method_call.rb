# frozen_string_literal: true

module Crispr
  module Mutations
    # Mutates method calls by altering the method name or arguments.
    class MethodCall < Base
      # Returns true if the node is a method call (:send).
      #
      # @param node [Parser::AST::Node]
      # @return [Boolean]
      def match?(node)
        node.type == :send
      end

      # Returns a list of mutated versions of the given method call.
      #
      # @param node [Parser::AST::Node]
      # @return [Array<Parser::AST::Node>]
      def mutations_for(node)
        return [] unless match?(node)

        original_receiver, original_method_name, *args = *node

        mutations = []

        # Replace method name with a placeholder
        mutations << s(:send, original_receiver, :foo, *args)

        # Add nil as an argument if none exist
        mutations << s(:send, original_receiver, original_method_name, s(:nil)) if args.empty?

        # Remove first argument if any exist
        mutations << s(:send, original_receiver, original_method_name, *args[1..]) if args.any?

        mutations
      end
    end
  end
end
