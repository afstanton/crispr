# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Comparison do
  subject(:mutator) { described_class.new }

  def extract_operator(node)
    node.children[1]
  end

  describe "#mutations_for" do
    {
      "a == b" => :!=,
      "a != b" => :==,
      "a < b" => :>=,
      "a <= b" => :>,
      "a > b" => :<=,
      "a >= b" => :<
    }.each do |source, expected_operator|
      it "mutates #{source} to use #{expected_operator}" do
        node = parse(source)
        mutation = mutator.mutations_for(node).first
        expect(mutation).to be_a(Parser::AST::Node)
        expect(extract_operator(mutation)).to eq(expected_operator)
      end
    end

    it_behaves_like "returns empty array for unrelated nodes", described_class, "foo"
  end
end
