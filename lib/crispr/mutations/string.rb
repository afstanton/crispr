# frozen_string_literal: true

require_relative "base"

module Crispr
  module Mutations
    # Mutates string literals like "hello"
    class String < Base
      def mutations_for(node)
        return [] unless node.is_a?(Parser::AST::Node)
        return [] unless node.type == :str

        original = node.children.first
        return [] unless original.is_a?(::String)

        mutations = []

        # Common string mutations
        mutations << s(:str, "")
        mutations << s(:str, "a")
        mutations << s(:str, "test")
        mutations << s(:str, original.reverse) unless original.empty?
        mutations << s(:str, original.upcase) unless original.upcase == original
        mutations << s(:str, original.downcase) unless original.downcase == original

        mutations << s(:str, "mutated")
        mutations << s(:nil)
        mutations
      end
    end
  end
end
