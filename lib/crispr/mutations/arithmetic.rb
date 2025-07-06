# frozen_string_literal: true

require_relative "base"

module Crispr
  module Mutations
    # Mutates arithmetic operations such as +, -, *, /, etc.
    class Arithmetic < Base
      COMMUTATIVE = {
        :+ => %i[- * / % **],
        :* => %i[+ - / % **]
      }.freeze

      NON_COMMUTATIVE = {
        :- => %i[+ * / % **],
        :/ => %i[+ - * % **],
        :% => %i[+ - * / **],
        :** => %i[+ - * / %]
      }.freeze

      # Returns mutated AST nodes for arithmetic expressions.
      #
      # @param node [Parser::AST::Node] the AST node to inspect
      # @return [Array<Parser::AST::Node>] mutated nodes
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node)
        return [] unless node.type == :send

        receiver, method_name, *args = node.children
        return [] unless args.size == 1
        return [] unless (COMMUTATIVE.keys + NON_COMMUTATIVE.keys).include?(method_name)

        replacements = COMMUTATIVE[method_name] || NON_COMMUTATIVE[method_name]
        mutations = replacements.map do |op|
          Parser::AST::Node.new(:send, [receiver, op, args.first])
        end

        # Additional mutations
        mutations << receiver
        mutations << args.first

        # For commutative operators, swap operands
        mutations << Parser::AST::Node.new(:send, [args.first, method_name, receiver]) if COMMUTATIVE.key?(method_name)

        mutations
      end
    end
  end
end
