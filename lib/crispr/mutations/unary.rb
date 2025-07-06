# frozen_string_literal: true

require_relative "base"

module Crispr
  module Mutations
    # Mutates unary operator expressions such as !x, -x, +x.
    class Unary < Base
      # Returns mutated AST nodes for unary operator nodes.
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<Parser::AST::Node>] mutated nodes
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node)
        return [] unless node.type == :send

        receiver, method_name, = node.children

        case method_name
        when :!
          [receiver].compact
        when :-@
          [Parser::AST::Node.new(:send, [receiver, :+@])]
        when :+@
          [Parser::AST::Node.new(:send, [receiver, :-@])]
        else
          []
        end
      end
    end
  end
end
