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
require_relative "mutations/range"
require_relative "mutations/regexp"
require_relative "mutations/symbol"
require_relative "mutations/string"
require_relative "mutations/block"
require_relative "mutations/rescue"

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
      Crispr::Mutations::Hash.new,
      Crispr::Mutations::Range.new,
      Crispr::Mutations::Regexp.new,
      Crispr::Mutations::Symbol.new,
      Crispr::Mutations::String.new,
      Crispr::Mutations::Block.new,
      Crispr::Mutations::Rescue.new
    ].freeze

    def initialize(source_code)
      @source_code = source_code
    end

    def mutations
      ast = Parser::CurrentRuby.parse(@source_code)
      return [] unless ast

      mutations = find_mutations(ast)
      mutations.map { |path, mutated_node| apply_mutation_and_unparse(ast, path, mutated_node) }
    end

    private

    def apply_mutation_and_unparse(original_ast, node_path, mutated_node)
      # Create a deep copy of the AST to avoid modifying the original
      copied_ast = Marshal.load(Marshal.dump(original_ast))

      # Replace the node at the specified path with the mutated_node
      modified_ast = replace_node_at_path(copied_ast, node_path, mutated_node)

      Unparser.unparse(modified_ast)
    end

    def replace_node_at_path(current_node, path, replacement_node)
      # If path is empty, we've reached the target node
      return replacement_node if path.empty?

      # If current node is not an AST node, we can't traverse further
      return current_node unless current_node.is_a?(Parser::AST::Node)

      # Get the next step in the path and the remaining path
      next_index, *remaining_path = path

      # If the index is out of bounds, return the current node unchanged
      return current_node if next_index >= current_node.children.size

      # Recursively replace in the child at next_index
      new_children = current_node.children.dup
      new_children[next_index] = replace_node_at_path(
        current_node.children[next_index],
        remaining_path,
        replacement_node
      )

      # Return updated node with new children
      current_node.updated(nil, new_children)
    end

    def find_mutations(node, path = [])
      return [] unless node.is_a?(Parser::AST::Node)

      # Find mutations for the current node
      local_mutations = MUTATORS.flat_map do |mutator|
        mutator.mutations_for(node).map { |mutated_form| [path.dup, mutated_form] }
      end

      # Find mutations in child nodes
      child_mutations = node.children.each_with_index.flat_map do |child, index|
        find_mutations(child, path + [index])
      end

      # Filter out nil mutations (from assignment.rb and potentially others)
      all_mutations = local_mutations + child_mutations
      all_mutations.reject { |_path, mutation| mutation.nil? }
    end
  end
end
