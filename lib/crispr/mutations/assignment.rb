# rubocop:disable Lint/BooleanSymbol
# frozen_string_literal: true

require_relative "base"

module Crispr
  module Mutations
    # Mutates local variable assignments like `x = value`
    class Assignment < Base
      # Returns mutated AST nodes for assignments
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<Parser::AST::Node>] mutated nodes
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node)
        return [] unless node.type == :lvasgn

        var_name, value_node = node.children
        return [] unless value_node

        mutations = []

        # Remove assignment entirely (i.e., drop it)
        mutations << nil

        # Common alternative values
        [:nil, s(:int, 0), s(:str, ""), s(:true), s(:false)].each do |replacement|
          rep_node = replacement.is_a?(Symbol) ? s(replacement) : replacement
          mutations << s(:lvasgn, var_name, rep_node)
        end

        # Invert boolean
        if value_node.type == :true
          mutations << s(:lvasgn, var_name, s(:false))
        elsif value_node.type == :false
          mutations << s(:lvasgn, var_name, s(:true))
        end

        # Negate numeric
        mutations << s(:lvasgn, var_name, s(:int, -value_node.children.first)) if value_node.type == :int

        mutations.compact
      end
    end
  end
end
# rubocop:enable Lint/BooleanSymbol
