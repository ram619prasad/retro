ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'parallel_tests/test/runtime_logger' if ENV['RECORD_RUNTIME']
require 'database_cleaner'
require 'simplecov'
require 'minitest/unit'
require 'mocha/minitest'


SimpleCov.start 'rails' do
  add_filter "app/mailers/application_mailer.rb"
  add_filter "app/models/application_record.rb"
  add_filter "app/jobs/application_job.rb"
  add_filter "app/controllers/concerns/"
  add_filter "app/models/concerns/"
end

Dir[Rails.root.join('lib/*.rb', 'commands/*.rb')].each {|file| load file }
DatabaseCleaner.strategy = :truncation


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
