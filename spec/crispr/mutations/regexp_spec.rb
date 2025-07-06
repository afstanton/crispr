# frozen_string_literal: true

require "spec_helper"

RSpec.describe Crispr::Mutations::Regexp do
  describe "#mutations_for" do
    it "flips case-insensitive flag" do
      node = parse("/abc/i")
      mutations = described_class.new.mutations_for(node)
      expect(mutations).to include(s(:regexp, s(:str, "abc"), 0))
    end

    it "removes all flags" do
      node = parse("/abc/imx")
      mutations = described_class.new.mutations_for(node)
      expect(mutations).to include(s(:regexp, s(:str, "abc"), 0))
    end

    it "removes the pattern entirely" do
      node = parse("/abc/")
      mutations = described_class.new.mutations_for(node)
      expect(mutations).to include(s(:regexp, s(:str, ""), s(:regopt)))
    end

    it "returns empty array for non-regexp nodes" do
      node = parse("42")
      mutations = described_class.new.mutations_for(node)
      expect(mutations).to eq([])
    end
  end
end
