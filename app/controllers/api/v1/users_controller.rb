# frozen_string_literal: true

# All User related endpoints can be found here.
module Api
  module V1
    # All User related endpoints can be found here.
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, only: %i[signin signup]

      def signin
        email = user_params[:email]
        password = user_params[:password]
        api_token = AuthenticateUser.call(email, password).result
        json_response({ api_token: api_token }, :ok)
      end

      def signup
        user = User.new(user_params)
        if user.save
          api_token = AuthenticateUser.call(user.email, user.password).result
          json_response({ api_token: api_token }, :created)
        else
          json_response({ errors: user.errors }, '422')
        end
      end

      def show
        user = User.find(params[:id])
        render json: user, status: 200
      end

      private

      def user_params
        params.permit(:email, :password, :name, :title, :password_confirmation)
      end
    end
  end
end
