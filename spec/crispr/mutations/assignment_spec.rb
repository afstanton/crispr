# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Assignment do
  subject(:mutator) { described_class.new }

  describe "#mutations_for" do
    it "mutates x = true to x = false" do
      node = parse("x = true")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("x = false"))
    end

    it "mutates x = false to x = true" do
      node = parse("x = false")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("x = true"))
    end

    it "mutates x = 5 to x = -5" do
      node = parse("x = 5")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("x = -5"))
    end

    it "includes default assignments" do
      node = parse("x = 'hello'")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("x = nil"))
      expect(mutations).to include(parse("x = 0"))
      expect(mutations).to include(parse("x = ''"))
      expect(mutations).to include(parse("x = true"))
      expect(mutations).to include(parse("x = false"))
    end

    it "returns empty array for unrelated nodes" do
      node = parse("x + y")
      expect(mutator.mutations_for(node)).to eq([])
    end
  end
end
