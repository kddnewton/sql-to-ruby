# SQL to Ruby

This is a small application that parses SQL queries and converts them into equivalent Ruby code using ActiveRecord. It is very much a work-in-progress.

## Development

After checking out the repo, run `bundle install` to get the dependencies. Then, run `bundle exec rackup` to start the server. Then you can view `http://localhost:9292` in your browser.

### Installing gda

If you have trouble installing the `gda` gem, it's likely because you don't have `libgda` on your system. If you're on mac, try running `brew install gda` using Homebrew. Once you have that, try installing the `gda` gem with `gem install libgda`. If that doesn't work because it's missing header files, you'll need to properly configure `pkg-config` and `PKG_CONFIG_PATH` until it works.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kddeisz/sql-to-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
