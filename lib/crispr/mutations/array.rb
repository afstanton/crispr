# frozen_string_literal: true

module Crispr
  module Mutations
    # Provides mutations for Ruby array nodes.
    class Array < Base
      # Generates mutated versions of an array node.
      #
      # @param node [Parser::AST::Node] the array node to mutate
      # @return [Array<Parser::AST::Node>] list of mutated nodes
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node) && node.type == :array

        mutations = []

        # Remove each element individually
        node.children.each_with_index do |_, index|
          new_elements = node.children.dup
          new_elements.delete_at(index)
          mutations << s(:array, *new_elements)
        end

        # Add nil to the end
        mutations << s(:array, *node.children, s(:nil))

        # Replace each element individually with nil
        node.children.each_with_index do |_, index|
          new_elements = node.children.dup
          new_elements[index] = s(:nil)
          mutations << s(:array, *new_elements)
        end

        # Replace all elements with nil
        mutations << s(:array, *::Array.new(node.children.size) { s(:nil) })

        mutations
      end
    end
  end
end
