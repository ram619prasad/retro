class Api::V1::UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:signin, :signup]

    def signin
        api_token = AuthenticateUser.call(user_params[:email], user_params[:password]).result
        json_response({ api_token: api_token }, :ok)
    end

    def signup
        user = User.new(user_params)
        if user.save
            api_token = AuthenticateUser.call(user.email, user.password)
            render json: user, status: 201
        else
            json_response({errors: user.errors}, '422')
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
