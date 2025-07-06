# frozen_string_literal: true

RSpec.shared_examples "returns empty array for unrelated nodes" do |mutator_class, unrelated_node_source|
  it "returns empty array for unrelated nodes" do
    mutator = mutator_class.new
    node = parse(unrelated_node_source)
    mutations = mutator.mutations_for(node)
    expect(mutations).to be_empty
  end
end
