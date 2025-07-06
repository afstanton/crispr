# frozen_string_literal: true

require "parser/current"
require "unparser"
require_relative "mutations/boolean"
require_relative "mutations/numeric"
require_relative "mutations/comparison"
require_relative "mutations/literal"
require_relative "mutations/unary"
require_relative "mutations/control_flow"
require_relative "mutations/conditional"
require_relative "mutations/logical"
require_relative "mutations/ternary"
require_relative "mutations/arithmetic"
require_relative "mutations/assignment"
require_relative "mutations/method_call"
require_relative "mutations/array"
require_relative "mutations/hash"

module Crispr
  # Mutator performs simple AST mutations on Ruby source code.
  # It delegates to multiple mutation strategies (Boolean, Numeric, etc.)
  class Mutator
    MUTATORS = [
      Crispr::Mutations::Boolean.new,
      Crispr::Mutations::Numeric.new,
      Crispr::Mutations::Comparison.new,
      Crispr::Mutations::Literal.new,
      Crispr::Mutations::Unary.new,
      Crispr::Mutations::ControlFlow.new,
      Crispr::Mutations::Conditional.new,
      Crispr::Mutations::Logical.new,
      Crispr::Mutations::Ternary.new,
      Crispr::Mutations::Arithmetic.new,
      Crispr::Mutations::Assignment.new,
      Crispr::Mutations::MethodCall.new,
      Crispr::Mutations::Array.new,
      Crispr::Mutations::Hash.new
    ].freeze

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

      local_mutations =
        MUTATORS.flat_map { |mutator| mutator.mutations_for(node) }

      child_mutations =
        node.children.flat_map { |child| find_mutations(child) }

      local_mutations + child_mutations
    end
  end
end
