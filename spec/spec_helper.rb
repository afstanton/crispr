# frozen_string_literal: true

require "simplecov"
require "simplecov-console"
require "simplecov-html"

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
                                                                  SimpleCov::Formatter::Console,
                                                                  SimpleCov::Formatter::HTMLFormatter
                                                                ])
SimpleCov.start

require "crispr"
require_relative "support/parser_helpers"
require_relative "support/shared_examples/mutation_shared_examples"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include ParserHelpers
end
