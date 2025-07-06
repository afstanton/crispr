# frozen_string_literal: true

require "crispr/mutator"
require "crispr/runner"
require "crispr/reporter"

module Crispr
  # Provides the command-line interface for the Crispr gem.
  # Handles argument parsing and invokes the mutation and runner logic.
  class CLI
    def self.run(argv = ARGV)
      command = argv.shift
      case command
      when "run"
        input_path = argv.shift
        unless input_path && File.exist?(input_path)
          puts "Error: Please specify a valid Ruby file or directory to mutate."
          exit 1
        end

        paths = File.directory?(input_path) ? Dir.glob("#{input_path}/**/*.rb") : [input_path]

        reporter = Crispr::Reporter.new

        paths.each do |path|
          source = File.read(path)
          mutator = Crispr::Mutator.new(source)
          mutations = mutator.mutations

          if mutations.empty?
            puts "No mutations found in #{path}."
            next
          end

          mutations.each_with_index do |mutated, index|
            puts "Running mutation #{index + 1}/#{mutations.size} on #{path}..."
            killed = Crispr::Runner.run_mutation(path: path, mutated_source: mutated)
            reporter.record(killed: killed)
            puts killed ? "💥 Mutation killed" : "⚠️ Mutation survived"
          end
        end

        summary = reporter.summary
        puts
        puts "Mutations: #{summary[:mutations]}"
        puts "💥 Killed: #{summary[:killed]}"
        puts "⚠️ Survived: #{summary[:survived]}"
        puts "Score: #{summary[:score]}%"
      else
        puts "Usage: crispr run path/to/file.rb"
        exit 1
      end
    end
  end
end
