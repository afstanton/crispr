# frozen_string_literal: true

require "crispr/mutations/boolean"
require "parser/current"

RSpec.describe Crispr::Mutations::Boolean do
  it "mutates true to false" do
    node = parse("true")
    mutations = described_class.new.mutations_for(node)
    expect(mutations).to include("false")
  end

  it "mutates false to true" do
    node = parse("false")
    mutations = described_class.new.mutations_for(node)
    expect(mutations).to include("true")
  end

  it "returns empty array for unrelated nodes" do
    node = parse("42")
    mutations = described_class.new.mutations_for(node)
    expect(mutations).to be_empty
  end
end
