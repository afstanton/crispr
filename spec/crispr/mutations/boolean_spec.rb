# frozen_string_literal: true

require "spec_helper"

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

  it_behaves_like "returns empty array for unrelated nodes", described_class, "42"
end
