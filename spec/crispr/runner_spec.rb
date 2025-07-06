# frozen_string_literal: true

require "crispr/runner"
require "fileutils"
require "tempfile"

RSpec.describe Crispr::Runner do
  let(:test_file_path) { File.join(Dir.pwd, "tmp_test.rb") }

  before do
    File.write(test_file_path, <<~RUBY)
      def working?
        true
      end
    RUBY
  end

  after do
    FileUtils.rm_f(test_file_path)
  end

  it "detects that the mutation is killed by the test suite" do
    File.write("spec/tmp_test_spec.rb", <<~RUBY)
      require_relative "../../tmp_test"

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

    result = described_class.run_mutation(path: test_file_path, mutated_source: mutated)
    expect(result).to be(true)

    FileUtils.rm_f("spec/tmp_test_spec.rb")
  end
end
