# frozen_string_literal: true

module Crispr
  module Mutations
    # Generates mutations for Ruby block nodes.
    # - Removes all block arguments.
    # - Removes the block body.
    # - Replaces the entire block with the method call only.
    class Block < Base
      def mutations_for(node)
        mutations = []

        method_call, args, body = *node

        # Remove all block arguments
        mutations << s(:block, method_call, s(:args), body) if args.is_a?(Parser::AST::Node) && args.type == :args && args.children.any?

        # Remove the block body
        mutations << s(:block, method_call, args, nil)

        # Replace block with just the method call
        mutations << method_call

        # Remove each individual statement if body is a :begin
        if body&.type == :begin
          body.children.each do |child|
            mutations << s(:block, method_call, args, child)
          end
        end

        mutations
      end
    end
  end
end
