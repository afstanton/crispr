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