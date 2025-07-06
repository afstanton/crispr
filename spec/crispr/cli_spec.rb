# frozen_string_literal: true

require "crispr/cli"

RSpec.describe Crispr::CLI do
  let(:mutator) { instance_double(Crispr::Mutator) }

  before do
    allow(File).to receive_messages(
      exist?: true,
      read: "def test; true; end"
    )

    allow(Crispr::Mutator).to receive(:new).and_return(mutator)
    allow(mutator).to receive_messages(
      mutations: ["def test; false; end"]
    )

    allow(Crispr::Runner).to receive(:run_mutation).and_return(true)
  end

  it "runs the CLI successfully with valid args" do
    expect { described_class.run(["run", "some_file.rb"]) }.to output(/💥 Mutation killed/).to_stdout
  end

  it "shows usage for unknown command" do
    expect { described_class.run(["invalid"]) }.to output(/Usage:/).to_stdout.and raise_error(SystemExit)
  end

  it "exits with error if no file is given" do
    expect do
      described_class.run(["run"])
    end.to output(/Error: Please specify a valid Ruby file or directory to mutate/).to_stdout.and raise_error(SystemExit)
  end

  it "exits with error if file does not exist" do
    allow(File).to receive(:exist?).and_return(false)
    expect do
      described_class.run(["run", "nonexistent.rb"])
    end.to output(/Error: Please specify a valid Ruby file or directory to mutate/).to_stdout.and raise_error(SystemExit)
  end

  it "exits with usage message if no command is provided" do
    expect do
      described_class.run([])
    end.to output(%r{Usage: crispr run path/to/file\.rb}).to_stdout.and raise_error(SystemExit)
  end

  it "exits if no mutations are found" do
    allow(mutator).to receive_messages(mutations: [])

    expect do
      described_class.run(["run", "some_file.rb"])
    end.to output(/No mutations found in/).to_stdout
  end
end
