# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      context '#signin' do
        setup do
          @user = FactoryBot.create(:user)
        end

        should 'return api_token if credentials are correct' do
          post signin_api_v1_users_url,
               params: { email: @user.email, password: @user.password }
          assert_response :success
          assert json_response.key?('api_token')
          assert_not_nil json_response['api_token']
        end

        should 'return error when invalid email is passed' do
          post signin_api_v1_users_url,
               params: { email: 'invalid@temp.com', password: @user.password }
          assert_response :not_found
          assert json_response.key?('message')
          assert_equal 'Sorry! Invalid email', json_response['message']
        end

        should 'return error when invalid password is passed' do
          post signin_api_v1_users_url,
               params: { email: @user.email, password: 'invalidPWD' }
          assert_response :unprocessable_entity
          assert json_response.key?('message')
          assert_equal 'Invalid Password', json_response['message']
        end
      end

      context '#signup' do
        setup do
          @params = { email: 'ram@gmail.com', name: 'Ram Prasad',
                      password: 'BigP@ssW0rd' }
        end

        should 'create user and return api_token if valid params are passed' do
          assert_difference 'User.count', +1 do
            post signup_api_v1_users_url, params: @params
          end
          assert_response :created
          assert json_response.key?('api_token')
          assert_not_nil json_response['api_token']
        end

        should 'throw errors when required params(like email) are missing' do
          assert_difference 'User.count', 0 do
            post signup_api_v1_users_url, params: @params.except(:email)
          end
          assert_response :unprocessable_entity
          assert json_response.key?('errors')
          assert json_response['errors'].key?('email')
        end
      end

      context '#show' do
        setup do
          @user = FactoryBot.create(:user)
        end

        should 'now work without Authorization header' do
          get api_v1_user_url(@user.id)
          assert_response :unauthorized
          assert json_response.key?('message')
          assert_equal 'Invalid request. No Authorization token' \
                       'present in headers.', json_response['message']
        end

        should 'return the user json_response when' \
               'Authorization header is passed' do
          get api_v1_user_url(@user.id),
              headers: { 'Authorization' => api_token }

          assert_response :success
          assert json_response.key?('data')

          %i[id type attributes links].each do |attr|
            assert json_response['data'].key?(attr.to_s),
                   "#{attr}.to_s is not present in data key of response"
          end
          assert_equal json_response['data']['id'].to_i, @user.id
          assert_equal 'users', json_response['data']['type']
          assert_equal "/api/v1/users/#{@user.id}/profile",
                       json_response['data']['links']['self']

          %i[name email title boards].each do |attr|
            assert json_response['data']['attributes'].key?(attr.to_s),
                   "#{attr}.to_s is not present in attributes key of response"
          end
          assert_equal json_response['data']['attributes']['name'],
                       @user.name
          assert_equal json_response['data']['attributes']['email'],
                       @user.email
          assert_equal json_response['data']['attributes']['title'],
                       @user.title
          assert_equal json_response['data']['attributes']['boards'],
                       @user.boards.count
        end
      end
    end
  end
end
