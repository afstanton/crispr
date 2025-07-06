# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Symbol do
  let(:mutator) { described_class.new }

  describe "#mutations_for" do
    it_behaves_like "returns empty array for unrelated nodes", described_class, "42"

    it "mutates :foo to other common symbols" do
      node = parse(":foo")
      mutations = mutator.mutations_for(node)

      expect(mutations).to include(s(:sym, :""))
      expect(mutations).to include(s(:sym, :mutated))
      expect(mutations).to include(s(:nil))
    end
  end
end
