# frozen_string_literal: true

module Crispr
  module Mutations
    # Abstract base class for all mutation strategies.
    # Subclasses must implement the `#mutations_for` method.
    class Base
      # Returns an array of mutated AST nodes for a given node.
      #
      # @param node [Parser::AST::Node] the node to mutate
      # @return [Array<Parser::AST::Node>] mutations
      def mutations_for(node)
        raise NotImplementedError, "#{self.class} must implement #mutations_for"
      end
    end
  end
end
