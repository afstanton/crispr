# frozen_string_literal: true

require_relative "base"

module Crispr
  module Mutations
    # Mutates logical operators like `&&` and `||`.
    class Logical < Base
      # Returns mutated AST nodes for logical expressions.
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<Parser::AST::Node>] mutated nodes
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node)

        case node.type
        when :and
          mutate_logical(node, :or)
        when :or
          mutate_logical(node, :and)
        else
          []
        end
      end

      private

      # Generate logical mutations by swapping type and extracting operands
      #
      # @param node [Parser::AST::Node]
      # @param opposite [Symbol] the alternate logical operator type
      # @return [Array<Parser::AST::Node>]
      def mutate_logical(node, opposite)
        left, right = node.children
        [
          Parser::AST::Node.new(opposite, [left, right]), # swap AND/OR
          left,
          right
        ]
      end
    end
  end
end
