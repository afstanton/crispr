# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Arithmetic do
  subject(:mutator) { described_class.new }

  def parse(source)
    Parser::CurrentRuby.parse(source)
  end

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

    it "returns empty array for non-arithmetic expressions" do
      node = parse("a == b")
      expect(mutator.mutations_for(node)).to eq([])
    end
  end
end
