# frozen_string_literal: true

require_relative "base"

module Crispr
  module Mutations
    # Defines mutations for comparison operators.
    # This includes flipping equality and inequality, and reversing inequality directions.
    class Comparison < Base
      COMPARISON_FLIPS = {
        :== => :!=,
        :!= => :==,
        :< => :>=,
        :<= => :>,
        :> => :<=,
        :>= => :<
      }.freeze

      # Returns a list of mutated AST nodes where comparisons are flipped.
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<Parser::AST::Node>] mutated nodes
      def mutations_for(node)
        return [] unless node.type == :send
        return [] unless COMPARISON_FLIPS.key?(node.children[1])

        flipped_operator = COMPARISON_FLIPS[node.children[1]]
        mutated_node = node.updated(nil, [node.children[0], flipped_operator, *node.children[2..]])
        [mutated_node]
      end
    end
  end
end
