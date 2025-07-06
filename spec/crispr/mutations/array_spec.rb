# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Array do
  let(:mutator) { described_class.new }

  it "adds nil to the end of an array" do
    node = parse("[1, 2]")
    mutations = mutator.mutations_for(node)
    expect(mutations).to include(s(:array, s(:int, 1), s(:int, 2), s(:nil)))
  end

  it "removes elements from the array" do
    node = parse("[1, 2, 3]")
    mutations = mutator.mutations_for(node)
    expect(mutations).to include(s(:array, s(:int, 1), s(:int, 3)))
    expect(mutations).to include(s(:array, s(:int, 2), s(:int, 3)))
    expect(mutations).to include(s(:array, s(:int, 1), s(:int, 2)))
  end

  it "replaces elements with nil" do
    node = parse("[1, 2]")
    mutations = mutator.mutations_for(node)
    expect(mutations).to include(s(:array, s(:nil), s(:int, 2)))
    expect(mutations).to include(s(:array, s(:int, 1), s(:nil)))
  end

  it_behaves_like "returns empty array for unrelated nodes", described_class, "1 + 2"
end
