# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Unary do
  subject(:mutator) { described_class.new }

  describe "#mutations_for" do
    it "mutates !x to x" do
      node = parse("!foo")
      mutations = mutator.mutations_for(node)
      expect(mutations.first).to eq(parse("foo"))
    end

    it "mutates -x to +x" do
      node = parse("-foo")
      mutations = mutator.mutations_for(node)
      expect(mutations.first).to eq(parse("+foo"))
    end

    it "mutates +x to -x" do
      node = parse("+foo")
      mutations = mutator.mutations_for(node)
      expect(mutations.first).to eq(parse("-foo"))
    end

    it_behaves_like "returns empty array for unrelated nodes", described_class, "foo + bar"
  end
end
