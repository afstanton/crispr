# frozen_string_literal: true

require "crispr/reporter"

RSpec.describe Crispr::Reporter do
  let(:reporter) { described_class.new }

  it "initializes with zero counts" do
    summary = reporter.summary
    expect(summary[:mutations]).to eq(0)
    expect(summary[:killed]).to eq(0)
    expect(summary[:survived]).to eq(0)
    expect(summary[:score]).to eq(0.0)
  end

  it "correctly tracks killed and survived mutations" do
    reporter.record(killed: true)
    reporter.record(killed: false)
    reporter.record(killed: true)

    summary = reporter.summary
    expect(summary[:mutations]).to eq(3)
    expect(summary[:killed]).to eq(2)
    expect(summary[:survived]).to eq(1)
    expect(summary[:score]).to eq(66.67)
  end

  it "reports 0.0 score when no mutations recorded" do
    expect(reporter.score).to eq(0.0)
  end
end
