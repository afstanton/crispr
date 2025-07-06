# Crispr

TODO: Delete this and the text below, and describe your gem

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/crispr`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/crispr.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

# Crispr

**Crispr** is a mutation testing tool for Ruby. It introduces small mutations into your code to test whether your existing test suite can detect and fail on them. This helps reveal gaps in your test coverage and improve confidence in your codebase.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "crispr"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install crispr
```

## Usage

Run Crispr against a specific file or directory:

```bash
crispr run path/to/your/code.rb
```

The tool will:
- Parse the code into an AST
- Apply simple mutations
- Re-run your test suite for each mutation
- Report which mutations survived (i.e., were not detected by tests)

## Development

After checking out the repo, run:

```bash
bin/setup
```

To run the tests:

```bash
rake spec
```

To install this gem onto your local machine:

```bash
bundle exec rake install
```

To release a new version, update the version number in `version.rb`, then run:

```bash
bundle exec rake release
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/afstanton/crispr](https://github.com/afstanton/crispr).

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
