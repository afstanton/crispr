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
      def mutations_for(node)
        return [] unless node.type == :rescue

        mutations = []

        # Remove the rescue entirely (just return the body before rescue)
        mutations << node.children[0] if node.children[0]

        # Replace the rescued body with nil
        mutations << s(:block, s(:rescue, node.children.first, s(:resbody, nil, nil, s(:nil)), nil), nil, nil)

        # Replace the rescued body with a different expression
        mutations << s(:rescue, s(:str, "error"), *node.children[1..])

        # Remove individual rescue clauses if present
        if node.children[1..] && !node.children[1..].empty?
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
