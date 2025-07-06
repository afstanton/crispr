# frozen_string_literal: true

require "crispr/runner"
require "fileutils"
require "tempfile"

RSpec.describe Crispr::Runner do
  let(:test_file_path) { File.join("spec", "tmp", "sample_code.rb") }

  before do
    FileUtils.mkdir_p("spec/tmp")
    File.write(test_file_path, <<~RUBY)
      def working?
        true
      end
    RUBY
  end

  after do
    FileUtils.rm_rf("spec/tmp")
  end

  it "detects that the mutation is killed by the test suite" do
    File.write("spec/tmp/sample_spec.rb", <<~RUBY)
      require_relative "sample_code"

      RSpec.describe "working?" do
        it "returns true" do
          expect(working?).to eq(true)
        end
      end
    RUBY

    mutated = <<~RUBY
      def working?
        false
      end
    RUBY

    result = described_class.run_mutation(
      path: test_file_path,
      mutated_source: mutated,
      test_path: "spec/tmp/sample_spec.rb"
    )
    expect(result).to be(true)

    FileUtils.rm_f("spec/tmp/sample_spec.rb")
  end
end
