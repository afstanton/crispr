# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Logical do
  subject(:mutator) { described_class.new }

  describe "#mutations_for" do
    it "mutates a && b to a || b, a, and b" do
      node = parse("a && b")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("a || b"), parse("a"), parse("b"))
    end

    it "mutates a || b to a && b, a, and b" do
      node = parse("a || b")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("a && b"), parse("a"), parse("b"))
    end

    it "returns empty array for non-logical nodes" do
      node = parse("a + b")
      mutations = mutator.mutations_for(node)
      expect(mutations).to eq([])
    end
  end
end
