# frozen_string_literal: true

require "parser/current"
require "unparser"
require_relative "mutations/boolean_mutations"

module Crispr
  # Mutator performs simple AST mutations on Ruby source code.
  # Currently, it supports changing `true` literals to `false` and vice versa.
  class Mutator
    def initialize(source_code)
      @source_code = source_code
    end

    def mutations
      ast = Parser::CurrentRuby.parse(@source_code)
      return [] unless ast

      find_mutations(ast)
    end

    private

    def find_mutations(node)
      return [] unless node.is_a?(Parser::AST::Node)

      local_mutations = Crispr::Mutations::BooleanMutations.mutations_for(node)
      child_mutations = node.children.flat_map { |child| find_mutations(child) }

      local_mutations + child_mutations
    end
  end
end
