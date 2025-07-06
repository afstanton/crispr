# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Base do
  let(:base_mutator) { described_class.new }

  describe "#mutations_for" do
    it "raises NotImplementedError" do
      node = instance_double(Parser::AST::Node)
      expect { base_mutator.mutations_for(node) }.to raise_error(NotImplementedError)
    end
  end
end
