# frozen_string_literal: true

require "open3"

module Crispr
  # Runner is responsible for executing tests against mutated code.
  # It temporarily replaces the file's source with a mutated version,
  # runs the test suite, and restores the original file afterward.
  class Runner
    # Runs the test suite with the mutated source code for the given file path.
    #
    # @param path [String] the path to the source file to mutate
    # @param mutated_source [String] the mutated version of the file's source code
    # @return [Boolean] true if the mutation was killed (test suite failed), false otherwise
    def self.run_mutation(path:, mutated_source:)
      original_source = File.read(path)

      begin
        File.write(path, mutated_source)

        stdout, stderr, status = Open3.capture3("bundle exec rspec")
        killed = !status.success?

        puts stdout unless status.success?
        puts stderr unless status.success?

        killed
      ensure
        File.write(path, original_source)
      end
    end
  end
end
