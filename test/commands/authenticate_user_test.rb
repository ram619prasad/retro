# frozen_string_literal: true

require 'test_helper'

class AuthenticateUserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  context '#call' do
    should 'return the json_web_token if we pass the' \
           'correct email and password' do
      api_token = AuthenticateUser.call(@user.email, @user.password)
      assert api_token
    end

    should 'raise ActiveRecord::RecordNotFound when invoked' \
           'with a user email which is not in db' do
      exception = assert_raises ActiveRecord::RecordNotFound do
        AuthenticateUser.call('invalid@gmail.com', @user.password)
      end

      assert_equal 'Sorry! Invalid email', exception.message
    end

    should 'raise ExceptionHandler::AuthenticationError' \
           'if password does not match' do
      exception = assert_raises ExceptionHandler::AuthenticationError do
        AuthenticateUser.call(@user.email, 'invalid_password')
      end

      assert_equal 'Invalid Password', exception.message
    end
  end
end
