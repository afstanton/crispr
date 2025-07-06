# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::MethodCall do
  let(:mutator) { described_class.new }

  describe "#mutations_for" do
    it "adds a nil argument to a method call with no args" do
      node = parse("foo()")

      mutations = mutator.mutations_for(node)

      expect(mutations.any? { |m| m.type == :send && m.children[2..]&.any? { |arg| arg.type == :nil } }).to be true
    end

    it "removes an argument from a method call with one arg" do
      node = parse("foo(42)")

      mutations = mutator.mutations_for(node)

      expect(mutations.any? { |m| m.type == :send && m.children[0..1] == [nil, :foo] && m.children.length == 2 }).to be true
    end

    it_behaves_like "returns empty array for unrelated nodes", described_class, "x = 5"
  end
end
