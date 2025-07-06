# frozen_string_literal: true

module Crispr
  module Mutations
    # Mutation class for handling Ruby range expressions (inclusive and exclusive).
    # Applies mutations such as flipping range type, replacing with nil, and swapping bounds.
    class Range < Base
      # Returns a list of mutated forms of the given range node.
      #
      # @param node [Parser::AST::Node] the AST node representing a range
      # @return [Array<Parser::AST::Node>] mutated AST nodes
      def mutations_for(node)
        return [] unless %i[irange erange].include?(node.type)

        left, right = node.children
        mutations = []

        # Flip the range type (inclusive <-> exclusive)
        flipped_type = node.type == :irange ? :erange : :irange
        mutations << s(flipped_type, left, right)

        # Replace with nil
        mutations << s(:nil)

        # Swap bounds if both sides are literals
        mutations << s(node.type, right, left) if left&.type == :int && right&.type == :int

        mutations
      end
    end
  end
end
