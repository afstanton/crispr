# rubocop:disable Lint/BooleanSymbol
# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Conditional do
  let(:mutator) { described_class.new }

  it "flips the condition using !" do
    node = parse("if x; y; end")
    mutations = mutator.mutations_for(node)

    flipped = mutations.find { |m| m.children[0]&.type == :send && m.children[0].children[1] == :! }
    expect(flipped).not_to be_nil
  end

  it "replaces the condition with true" do
    node = parse("if x; y; end")
    mutations = mutator.mutations_for(node)

    expect(mutations).to include(s(:if, s(:true), s(:send, nil, :y), nil))
  end

  it "replaces the condition with false" do
    node = parse("if x; y; end")
    mutations = mutator.mutations_for(node)

    expect(mutations).to include(s(:if, s(:false), s(:send, nil, :y), nil))
  end
end
# rubocop:enable Lint/BooleanSymbol
