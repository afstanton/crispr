# rubocop:disable Lint/BooleanSymbol
# frozen_string_literal: true

require_relative "base"

module Crispr
  module Mutations
    # Mutates basic Ruby literals to edge-case or alternate values.
    class Literal < Base
      # Returns mutated AST nodes for literal types.
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<Parser::AST::Node>] mutated nodes
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node)

        case node.type
        when :int
          [replace_literal(node, 0), replace_literal(node, -1), replace_literal(node, 1)].uniq
        when :str
          [replace_literal(node, ""), replace_literal(node, "crispr")]
        when :sym
          [replace_literal(node, :other)]
        when :array
          [Parser::AST::Node.new(:array, [])]
        when :hash
          [Parser::AST::Node.new(:hash, [])]
        when :true
          [replace_literal(node, false)]
        when :false
          [replace_literal(node, true)]
        when :nil
          [Parser::AST::Node.new(:str, ["null"])]
        else
          []
        end
      end

      private

      def replace_literal(original, new_value)
        Parser::AST::Node.new(original.type, [new_value])
      end
    end
  end
end
# rubocop:enable Lint/BooleanSymbol
