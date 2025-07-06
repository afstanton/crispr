# frozen_string_literal: true

module Crispr
  # Reporter collects mutation testing results and prints a summary.
  class Reporter
    # Initializes a new Reporter.
    def initialize
      @killed = 0
      @survived = 0
    end

    # Records the result of a mutation test.
    #
    # @param killed [Boolean] whether the mutation was killed
    # @return [void]
    def record(killed:)
      killed ? @killed += 1 : @survived += 1
    end

    # Returns the mutation score as a percentage.
    #
    # @return [Float] the mutation score
    def score
      total = @killed + @survived
      total.zero? ? 0.0 : (@killed.to_f / total * 100).round(2)
    end

    # Returns a summary of mutation results.
    #
    # @return [Hash] summary statistics including totals and score
    def summary
      total = @killed + @survived
      {
        mutations: total,
        killed: @killed,
        survived: @survived,
        score: score
      }
    end
  end
end
