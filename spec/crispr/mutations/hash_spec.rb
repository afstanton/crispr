# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Hash do
  describe "#mutations_for" do
    let(:mutator) { described_class.new }

    it "removes a key-value pair" do
      node = parse("{ a: 1, b: 2 }")
      mutations = mutator.mutations_for(node)

      expect(mutations.any? do |m|
        m.type == :hash && m.children.size == 1 &&
        %i[a b].include?(m.children[0].children[0].children[0])
      end).to be true
    end

    it "adds a nil key-value pair" do
      node = parse("{ a: 1 }")
      mutations = mutator.mutations_for(node)

      expect(mutations).to include(
        s(:hash,
          s(:pair, s(:sym, :a), s(:int, 1)),
          s(:pair, s(:nil), s(:nil)))
      )
    end

    it "replaces values with nil" do
      node = parse("{ a: 1, b: 2 }")
      mutations = mutator.mutations_for(node)

      expect(mutations).to include(
        s(:hash,
          s(:pair, s(:sym, :a), s(:nil)),
          s(:pair, s(:sym, :b), s(:int, 2)))
      )
    end

    it_behaves_like "returns empty array for unrelated nodes", described_class, "1 + 2"
  end
end
