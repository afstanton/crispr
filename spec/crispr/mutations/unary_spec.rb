# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Unary do
  subject(:mutator) { described_class.new }

  def parse(source)
    Parser::CurrentRuby.parse(source)
  end

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

    it "returns empty array for non-unary expressions" do
      node = parse("foo + bar")
      mutations = mutator.mutations_for(node)
      expect(mutations).to be_empty
    end
  end
end
