# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::ControlFlow do
  subject(:mutator) { described_class.new }

  describe "#mutations_for" do
    it "mutates next to break and nil" do
      node = parse("next 1")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("break 1"), parse("nil"))
    end

    it "mutates break to next and nil" do
      node = parse("break 2")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("next 2"), parse("nil"))
    end

    it "mutates return with value to return without value and nil" do
      node = parse("return 3")
      mutations = mutator.mutations_for(node)
      expect(mutations).to include(parse("return"), parse("nil"))
    end

    it_behaves_like "returns empty array for unrelated nodes", described_class, "puts 'hi'"
  end
end
