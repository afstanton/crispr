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

    it "returns empty array for non-comparison nodes" do
      node = parse("foo")
      expect(mutator.mutations_for(node)).to eq([])
    end
  end
end
