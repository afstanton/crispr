# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Block do
  describe "#mutations_for" do
    it "removes the entire block body" do
      node = parse("foo { bar }")
      mutations = described_class.new.mutations_for(node)
      expect(mutations).to include(parse("foo {}"))
    end

    it "removes each individual statement from the block" do
      node = parse("foo { bar; baz }")
      mutations = described_class.new.mutations_for(node)
      expect(mutations).to include(parse("foo { baz }"))
      expect(mutations).to include(parse("foo { bar }"))
    end

    it "removes the block entirely, leaving the method call" do
      node = parse("foo { bar }")
      mutations = described_class.new.mutations_for(node)
      expect(mutations).to include(parse("foo"))
    end
  end

  it_behaves_like "returns empty array for unrelated nodes", described_class, "1 + 1"
end
