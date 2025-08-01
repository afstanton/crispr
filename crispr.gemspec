# frozen_string_literal: true

require_relative "lib/crispr/version"

Gem::Specification.new do |spec|
  spec.name = "crispr"
  spec.version = Crispr::VERSION
  spec.authors = ["Aaron F Stanton"]
  spec.email = ["afstanton@gmail.com"]

  spec.summary = "A mutation testing framework for Ruby."
  spec.description = "Crispr is a mutation testing tool for Ruby that introduces " \
                     "small code mutations to verify the effectiveness of your test suite."
  spec.homepage = "https://github.com/afstanton/crispr"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/afstanton/crispr"
  spec.metadata["changelog_uri"] = "https://github.com/afstanton/crispr/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["crispr"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_dependency "parser", "~> 3.3.8"
  spec.add_dependency "unparser", "~> 0.8.0"
end
