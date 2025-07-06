# frozen_string_literal: true

require "parser/current"
require "unparser"

module Crispr
  # Mutator performs simple AST mutations on Ruby source code.
  # Currently, it supports changing `true` literals to `false`.
  # Future versions will support more mutation types and metadata.
  class Mutator
    def initialize(source_code)
      @source_code = source_code
    end

    def mutations
      ast = Parser::CurrentRuby.parse(@source_code)
      return [] unless ast

      # Apply a simple mutation: change `true` → `false`
      find_mutations(ast)
    end

    private

    def find_mutations(node)
      return [] unless node.is_a?(Parser::AST::Node)

      if node.type == true
        mutated = Parser::AST::Node.new(false)
        [Unparser.unparse(mutated)]
      else
        node.children.flat_map { |child| find_mutations(child) }
      end
    end
  end
end
