# frozen_string_literal: true

# Module which is responsible for handling all the exception
# that are raised in the app.
module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class AuthorizationError < StandardError; end
  class InvalidToken < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ExceptionHandler::AuthenticationError,
                with: :unprocessible_entity
    rescue_from ExceptionHandler::AuthorizationError,
                with: :unauthorized_request
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessible_entity
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unprocessible_entity
    rescue_from CanCan::AccessDenied, with: :forbidden
  end

  def not_found(err)
    json_rrrsponse({ message: err.message }, :not_found)
  end

  def unauthorized_request(err)
    json_response({ message: err.message }, :unauthorized_request)
  end

  def unprocessible_entity(err)
    json_response({ message: err.message }, :unprocessible_entity)
  end

  def forbidden
    json_response({ message: 'You are not authorized to' \
                    'perform this action' }, :forbidden)
  end
end
