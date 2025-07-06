# frozen_string_literal: true

module Crispr
  module Mutations
    # This class generates mutations for symbol nodes in the AST.
    # It provides different mutated versions of a symbol node for mutation testing.
    class Symbol < Base
      # Returns a list of mutated versions of a symbol node.
      #
      # @param node [Parser::AST::Node]
      # @return [Array<Parser::AST::Node>]
      def mutations_for(node)
        return [] unless node.type == :sym

        value = node.children.first
        mutations = []

        # Change the symbol to an empty symbol
        mutations << s(:sym, :"") unless value == :""

        # Change the symbol to a different symbol
        mutations << s(:sym, :mutated) unless value == :mutated

        # Remove the symbol node entirely (i.e., replace with nil)
        mutations << s(:nil)

        mutations
      end
    end
  end
end
