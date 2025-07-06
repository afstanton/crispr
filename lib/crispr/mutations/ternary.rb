# frozen_string_literal: true

require_relative "base"

module Crispr
  module Mutations
    # Mutates ternary expressions like `cond ? a : b`
    class Ternary < Base
      # Returns mutated AST nodes for ternary expressions.
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<Parser::AST::Node>] mutated nodes
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node)
        return [] unless node.type == :if
        return [] unless node.loc.respond_to?(:question) && node.loc.question

        cond, if_branch, else_branch = node.children
        [
          if_branch,
          else_branch,
          cond,
          Parser::AST::Node.new(:if, [cond, else_branch, if_branch]) # swap branches
        ].compact
      end
    end
  end
end
