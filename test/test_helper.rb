# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'parallel_tests/test/runtime_logger' if ENV['RECORD_RUNTIME']
require 'database_cleaner'
require 'simplecov'
require 'minitest/unit'
require 'mocha/minitest'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

SimpleCov.start 'rails' do
  add_filter 'app/mailers/application_mailer.rb'
  add_filter 'app/models/application_record.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/controllers/concerns/'
  add_filter 'app/models/concerns/'
end

Dir[Rails.root.join('lib/*.rb', 'commands/*.rb')].each { |file| load file }
DatabaseCleaner.strategy = :truncation

module ActiveSupport
  class TestCase
    # Add more helper methods to be used by all tests here...
    def setup
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
    end

    # For generating api_token which can be used in testing controller actions
    def api_token
      user = FactoryBot.create(:user)
      payload = { user_id: user.id }
      JsonWebToken.encode(payload)
    end

    def current_user(token)
      user_id = JsonWebToken.decode(token)['user_id']
      User.find(user_id)
    end

    def json_response
      JSON.parse(@response.body)
    end

    def unauthorized_route_assertions
      assert_response :unauthorized
      assert json_response.key?('message')
      assert_equal 'Invalid request. No Authorization token' \
        'present in headers.', json_response['message']
    end

    def forbidden_assertions
      assert_response :forbidden
      assert json_response.key?('message')
      assert_equal 'You are not authorized to perform' \
        'this action', json_response['message']
    end
  end
end
