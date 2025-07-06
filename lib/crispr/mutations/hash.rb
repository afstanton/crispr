# frozen_string_literal: true

module Crispr
  module Mutations
    # Mutations targeting hash literals.
    class Hash < Base
      # Returns an array of mutated versions of the given hash node.
      #
      # @param node [Parser::AST::Node] the hash AST node
      # @return [Array<Parser::AST::Node>] mutated AST nodes
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node) && node.type == :hash

        mutations = []

        node.children.each_with_index do |pair, index|
          # Remove individual pair
          new_pairs = node.children.dup
          new_pairs.delete_at(index)
          mutations << s(:hash, *new_pairs)

          # Replace value with nil
          next unless pair.type == :pair

          key, _value = *pair
          new_pair = s(:pair, key, s(:nil))
          new_pairs = node.children.dup
          new_pairs[index] = new_pair
          mutations << s(:hash, *new_pairs)
        end

        # Add a new nil => nil pair
        mutations << s(:hash, *(node.children + [s(:pair, s(:nil), s(:nil))]))

        mutations
      end
    end
  end
end
