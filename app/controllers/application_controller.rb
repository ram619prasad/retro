# frozen_string_literal: true

# Base class for all the controllers in our app.
class ApplicationController < ActionController::API
  include Response # For rendering json_response
  include ExceptionHandler

  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeUser.call(request.headers).result[:user]
    raise(ExceptionHandler::AuthorizationError,
          'User is not authorized to perform this action') if @current_user.nil?
  end
end
