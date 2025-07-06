# frozen_string_literal: true

require "crispr/mutator"

RSpec.describe Crispr::Mutations::Rescue do
  let(:source) { <<~RUBY }
    begin
      dangerous
    rescue
      fallback
    end
  RUBY

  let(:mutations) { Crispr::Mutator.new(source).mutations }

  it "removes the rescue clause entirely" do
    expect(mutations).to include(
      s(:rescue, s(:send, nil, :dangerous), nil)
    )
  end

  it "replaces rescue body with nil" do
    expect(mutations).to include(
      s(:block,
        s(:rescue,
          s(:send, nil, :dangerous),
          s(:resbody, nil, nil, s(:nil)),
          nil),
        nil,
        nil)
    )
  end
end
