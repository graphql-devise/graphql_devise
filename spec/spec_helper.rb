# frozen_string_literal: true

if ENV['CI'] && !ENV['SKIP_COVERALLS']
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start 'rails' do
    add_filter ['spec']
  end
end

require 'pry'
require 'bundler/setup'
require 'graphql_devise'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
