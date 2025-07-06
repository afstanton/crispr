# frozen_string_literal: true

require_relative "base"

module Crispr
  module Mutations
    # The Numeric class defines mutations for integer literals.
    # It generates alternative integer nodes by applying small transformations,
    # such as incrementing, decrementing, zeroing, or negating the value.
    class Numeric < Base
      # Applies numeric mutations to the given AST node.
      #
      # @param node [Parser::AST::Node] the node to mutate
      # @return [Array<Parser::AST::Node>] an array of mutated nodes
      def mutations_for(node)
        return [] unless node.type == :int

        value = node.children[0]

        # Generate a set of numeric mutations
        mutations = []
        mutations << replace(node, value + 1)
        mutations << replace(node, value - 1)
        mutations << replace(node, 0) unless value.zero?
        mutations << replace(node, -value) unless value.zero?

        mutations
      end

      private

      # Creates a new AST node with the given integer value.
      #
      # @param node [Parser::AST::Node] the original node
      # @param new_value [Integer] the new integer value
      # @return [Parser::AST::Node] the mutated node
      def replace(node, new_value)
        Parser::AST::Node.new(:int, [new_value], location: node.location)
      end
    end
  end
end
