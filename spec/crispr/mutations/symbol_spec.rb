# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Symbol do
  let(:mutator) { described_class.new }

  describe "#mutations_for" do
    it "returns an empty array for non-symbol nodes" do
      node = parse("42")
      expect(mutator.mutations_for(node)).to eq([])
    end

    it "mutates :foo to other common symbols" do
      node = parse(":foo")
      mutations = mutator.mutations_for(node)

      expect(mutations).to include(s(:sym, :""))
      expect(mutations).to include(s(:sym, :mutated))
      expect(mutations).to include(s(:nil))
    end
  end
end
