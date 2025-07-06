# rubocop:disable Lint/BooleanSymbol
# frozen_string_literal: true

module Crispr
  module Mutations
    # Provides boolean-specific AST mutations.
    # Currently supports toggling `true` to `false` and `false` to `true`.
    module Boolean
      # Returns a list of stringified mutated forms for the given boolean AST node.
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<String>] mutated Ruby source code strings
      def self.mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node)

        case node.type
        when :true
          [Unparser.unparse(Parser::AST::Node.new(:false))]
        when :false
          [Unparser.unparse(Parser::AST::Node.new(:true))]
        else
          []
        end
      end
    end
  end
end
# rubocop:enable Lint/BooleanSymbol
