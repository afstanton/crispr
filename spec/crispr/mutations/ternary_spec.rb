# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Ternary do
  subject(:mutator) { described_class.new }

  describe "#mutations_for" do
    it "returns if_branch, else_branch, condition, and swapped ternary" do
      node = parse("x ? 1 : 2")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("1"))
      expect(mutations).to include(parse("2"))
      expect(mutations).to include(parse("x"))
      expect(mutations).to include(parse("x ? 2 : 1"))
    end

    it "returns empty array for non-ternary if statements" do
      node = parse("if x then 1 else 2 end")
      mutations = mutator.mutations_for(node)
      expect(mutations).to be_empty
    end

    it "returns empty array for unrelated nodes" do
      node = parse("a + b")
      expect(mutator.mutations_for(node)).to eq([])
    end
  end
end
