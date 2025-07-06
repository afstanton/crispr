# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::String do
  describe "#mutations_for" do
    let(:node) { parse('"HELLO"') }
    let(:mutations) { described_class.new.mutations_for(node) }

    it "includes an empty string" do
      expect(mutations).to include(s(:str, ""))
    end

    it "includes a reversed string" do
      expect(mutations).to include(s(:str, "OLLEH"))
    end

    it "includes a downcased string" do
      expect(mutations).to include(s(:str, "hello"))
    end

    it "includes a mutated string" do
      expect(mutations).to include(s(:str, "mutated"))
    end

    it "includes nil" do
      expect(mutations).to include(s(:nil))
    end

    it_behaves_like "returns empty array for unrelated nodes", described_class, "1 + 1"
  end
end
