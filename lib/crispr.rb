# frozen_string_literal: true

require_relative "crispr/version"
require_relative "crispr/mutator"
require_relative "crispr/runner"
require_relative "crispr/cli"

require_relative "crispr/mutations/base"
require_relative "crispr/mutations/boolean"
require_relative "crispr/mutations/numeric"

module Crispr
  class Error < StandardError; end
  # Your code goes here...
end
