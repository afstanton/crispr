# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Literal do
  subject(:mutator) { described_class.new }

  def extract_mutation_values(nodes)
    nodes.map(&:children).flatten
  end

  describe "#mutations_for" do
    it "mutates integer literals" do
      node = parse("42")
      values = extract_mutation_values(mutator.mutations_for(node))
      expect(values).to include(0, -1, 1)
    end

    it "mutates string literals" do
      node = parse('"hello"')
      values = extract_mutation_values(mutator.mutations_for(node))
      expect(values).to include("", "crispr")
    end

    it "mutates symbol literals" do
      node = parse(":foo")
      values = extract_mutation_values(mutator.mutations_for(node))
      expect(values).to include(:other)
    end

    it "mutates array literals" do
      node = parse("[1, 2, 3]")
      mutations = mutator.mutations_for(node)
      expect(mutations.map(&:children)).to include([])
    end

    it "mutates hash literals" do
      node = parse("{ a: 1 }")
      mutations = mutator.mutations_for(node)
      expect(mutations.map(&:children)).to include([])
    end

    it "mutates true to false" do
      node = parse("true")
      values = extract_mutation_values(mutator.mutations_for(node))
      expect(values).to include(false)
    end

    it "mutates false to true" do
      node = parse("false")
      values = extract_mutation_values(mutator.mutations_for(node))
      expect(values).to include(true)
    end

    it "mutates nil to string 'null'" do
      node = parse("nil")
      mutations = mutator.mutations_for(node)
      expect(mutations.first.type).to eq(:str)
      expect(mutations.first.children.first).to eq("null")
    end
  end
end
