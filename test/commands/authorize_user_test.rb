# frozen_string_literal: true

require 'test_helper'

class AuthorizeUserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
    @api_token = AuthenticateUser.call(@user.email, @user.password).result
    @headers = { 'Authorization' => @api_token }
  end

  context '#call' do
    should 'return the user if headers include correct Authorization token' do
      user = AuthorizeUser.call(@headers).result[:user]
      assert_equal @user, user
    end

    should 'raise ExceptionHandler::MissingToken when no' \
           'authorization header is sent' do
      assert_raises ExceptionHandler::MissingToken do
        AuthorizeUser.call({})
      end

      assert_equal 'Invalid request. No Authorization token' \
                   'present in headers.', exception.message
    end

    should 'raise ExceptionHandler::InvalidToken when an invalid' \
           'token is sent in header' do
      api_token = @api_token.gsub!(/\d+/, 'a')
      assert_raises ExceptionHandler::InvalidToken do
        AuthorizeUser.call('Authorization' => api_token)
      end
    end

    should 'raise ExceptionHandler::InvalidToken when a user is not' \
           'found with the given token' do
      @user.destroy
      assert_raises ExceptionHandler::InvalidToken do
        AuthorizeUser.call(@headers)
      end

      assert_equal 'Invalid Token', exception.message
    end
  end
end
