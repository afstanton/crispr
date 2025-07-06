# rubocop:disable Lint/BooleanSymbol
# frozen_string_literal: true

module Crispr
  module Mutations
    # Mutates conditional expressions like `if`, `unless`, etc.
    #
    # This mutator generates mutations for the condition part of a conditional expression.
    # It flips the condition, replaces it with `true`, or replaces it with `false`.
    class Conditional < Base
      # Returns a list of mutated forms for the given AST node.
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<Parser::AST::Node>] mutated AST nodes
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node)
        return [] unless %i[if unless].include?(node.type)

        condition, then_branch, else_branch = *node
        mutations = []

        # Flip condition using a logical not
        flipped_condition = s(:send, condition, :!)
        mutations << s(node.type, flipped_condition, then_branch, else_branch)

        # Replace condition with `true`
        mutations << s(node.type, s(:true), then_branch, else_branch)

        # Replace condition with `false`
        mutations << s(node.type, s(:false), then_branch, else_branch)

        mutations
      end
    end
  end
end
# rubocop:enable Lint/BooleanSymbol
