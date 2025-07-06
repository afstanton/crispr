# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Numeric do
  subject(:mutator) { described_class.new }

  describe "#mutations_for" do
    context "when node is an integer" do
      it "generates increment and decrement mutations" do
        node = parse("5")
        mutations = mutator.mutations_for(node)

        values = mutations.map { |m| m.children[0] }
        expect(values).to include(6, 4)
      end

      it "generates zero and negation mutations when not zero" do
        node = parse("3")
        mutations = mutator.mutations_for(node)

        values = mutations.map { |m| m.children[0] }
        expect(values).to include(0, -3)
      end

      it "does not include zero/negation mutations for zero" do
        node = parse("0")
        mutations = mutator.mutations_for(node)

        values = mutations.map { |m| m.children[0] }
        expect(values).not_to include(0, 0)
        expect(values).not_to include(-0)
      end
    end

    context "when node is not an integer" do
      it_behaves_like "returns empty array for unrelated nodes", described_class, "true"
    end
  end
end
