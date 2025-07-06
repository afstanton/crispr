# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Range do
  let(:mutator) { described_class.new }

  it "mutates inclusive range to exclusive range" do
    node = parse("1..5")
    mutations = mutator.mutations_for(node)
    expect(mutations).to include(parse("1...5"))
  end

  it "mutates exclusive range to inclusive range" do
    node = parse("1...5")
    mutations = mutator.mutations_for(node)
    expect(mutations).to include(parse("1..5"))
  end

  it_behaves_like "returns empty array for unrelated nodes", described_class, "1 + 1"
end
