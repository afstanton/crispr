# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Arithmetic do
  subject(:mutator) { described_class.new }

  describe "#mutations_for" do
    it "mutates a + b to other ops and swapped a and b" do
      node = parse("a + b")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("a - b"))
      expect(mutations).to include(parse("a * b"))
      expect(mutations).to include(parse("a / b"))
      expect(mutations).to include(parse("a % b"))
      expect(mutations).to include(parse("a ** b"))
      expect(mutations).to include(parse("b + a"))
      expect(mutations).to include(parse("a"))
      expect(mutations).to include(parse("b"))
    end

    it "mutates a - b to other ops (no swapped a and b)" do
      node = parse("a - b")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("a + b"))
      expect(mutations).to include(parse("a * b"))
      expect(mutations).to include(parse("a / b"))
      expect(mutations).to include(parse("a % b"))
      expect(mutations).to include(parse("a ** b"))
      expect(mutations).not_to include(parse("b - a")) # no commutative swap
      expect(mutations).to include(parse("a"))
      expect(mutations).to include(parse("b"))
    end

    it_behaves_like "returns empty array for unrelated nodes", described_class, "x = 1"
  end
end
