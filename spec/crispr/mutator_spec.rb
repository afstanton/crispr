# frozen_string_literal: true

require "crispr/mutator"

RSpec.describe Crispr::Mutator do
  it "mutates `true` to `false`" do
    source = "def valid?\n  true\nend"
    mutator = described_class.new(source)
    mutations = mutator.mutations

    expect(mutations).to include("false")
  end
end
