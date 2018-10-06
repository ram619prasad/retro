ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'parallel_tests/test/runtime_logger' if ENV['RECORD_RUNTIME']
require 'database_cleaner'
require 'simplecov'


SimpleCov.start 'rails' do
  add_filter "app/mailers/application_mailer.rb"
  add_filter "app/models/application_record.rb"
  add_filter "app/jobs/application_job.rb"
end

DatabaseCleaner.strategy = :truncation

# then, whenever you need to clean the DB
# DatabaseCleaner.clean

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
