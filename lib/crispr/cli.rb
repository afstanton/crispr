require "crispr/mutator"
require "crispr/runner"

module Crispr
  class CLI
    def self.run(argv = ARGV)
      command = argv.shift
      case command
      when "run"
        path = argv.shift
        unless path && File.exist?(path)
          puts "Error: Please specify a valid Ruby file to mutate."
          exit 1
        end

        source = File.read(path)
        mutator = Crispr::Mutator.new(source)
        mutations = mutator.mutations

        if mutations.empty?
          puts "No mutations found."
          exit 0
        end

        mutations.each_with_index do |mutated, index|
          puts "Running mutation #{index + 1}/#{mutations.size}..."
          killed = Crispr::Runner.run_mutation(path: path, mutated_source: mutated)
          puts killed ? "💥 Mutation killed" : "⚠️ Mutation survived"
        end
      else
        puts "Usage: crispr run path/to/file.rb"
        exit 1
      end
    end
  end
end
