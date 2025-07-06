# frozen_string_literal: true

module Crispr
  module Mutations
    # Generates mutations for `rescue` nodes.
    #
    # Possible mutations include:
    # - Removing the entire rescue and returning only the main body.
    # - Replacing the rescued body with `nil` or a string.
    # - Removing individual rescue clauses from the rescue expression.
    class Rescue < Base
      def match?(node)
        node.type == :rescue
      end

      def mutations_for(node)
        mutations = []

        # Remove the rescue entirely (just return the body before rescue)
        mutations << node.children[0] if node.children[0]

        # Replace the rescued body with nil
        mutations << s(:rescue, s(:nil), *node.children[1..])

        # Replace the rescued body with a different expression
        mutations << s(:rescue, s(:str, "error"), *node.children[1..])

        # Remove individual rescue clauses if present
        if node.children[1..].any?
          node.children[1..].each_with_index do |_rescue_clause, i|
            new_children = node.children.dup
            new_children.delete_at(i + 1) # +1 to skip the body
            mutations << s(:rescue, *new_children)
          end
        end

        mutations
      end
    end
  end
end
