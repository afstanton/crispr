# frozen_string_literal: true

require_relative "base"

module Crispr
  module Mutations
    # Mutates control flow keywords like `next`, `break`, and `return`.
    class ControlFlow < Base
      # Returns mutated AST nodes for control flow constructs.
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<Parser::AST::Node>] mutated nodes
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node)

        case node.type
        when :next
          [Parser::AST::Node.new(:break, node.children), Parser::AST::Node.new(:nil)]
        when :break
          [Parser::AST::Node.new(:next, node.children), Parser::AST::Node.new(:nil)]
        when :return
          [Parser::AST::Node.new(:return, []), Parser::AST::Node.new(:nil)]
        else
          []
        end
      end
    end
  end
end
