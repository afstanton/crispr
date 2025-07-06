# frozen_string_literal: true

module Crispr
  module Mutations
    # Generates mutations for regular expressions
    class Regexp < Base
      # Returns a list of mutated forms for the given Regexp AST node.
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<Parser::AST::Node>] mutated AST nodes
      def mutations_for(node)
        return [] unless node.type == :regexp

        parts = node.children[0...-1]
        options = node.children.last

        mutations = []

        # Remove options if present
        mutations << s(:regexp, *parts, 0) if options != 0

        # Remove the pattern entirely
        mutations << s(:regexp, s(:str, ""), options)

        mutations
      end
    end
  end
end
