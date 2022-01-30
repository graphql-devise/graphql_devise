# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
GQL_DEVISE_ROOT = File.join(File.dirname(__FILE__), '../')

require File.expand_path('dummy/config/environment.rb', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'factory_bot'
require 'faker'
require 'generator_spec'

# Load RSpec helpers.
Dir[File.join(GQL_DEVISE_ROOT, 'spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migrator.migrations_paths = [
    File.join(GQL_DEVISE_ROOT, 'spec/dummy/db/migrate'),
    File.join(GQL_DEVISE_ROOT, 'spec/db/migrate')
  ]
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.fixture_path = "#{GQL_DEVISE_ROOT}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include(Requests::JsonHelpers, type: :request)
  config.include(Requests::AuthHelpers, type: :request)
  config.include(ActiveSupport::Testing::TimeHelpers)

  config.before(:suite) do
    ActionController::Base.allow_forgery_protection = true
  end
  config.before { ActionMailer::Base.deliveries.clear }
end
