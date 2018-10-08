module ExceptionHandler
    extend ActiveSupport::Concern

    class AuthenticationError < StandardError; end
    class MissingToken < StandardError; end
    class AuthorizationError < StandardError; end
    class InvalidToken < StandardError; end

    included do
        rescue_from ActiveRecord::RecordNotFound, with: :not_found
        rescue_from ExceptionHandler::AuthenticationError, with: :unprocessible_entity
        rescue_from ExceptionHandler::AuthorizationError, with: :unauthorized_request
        rescue_from ActiveRecord::RecordInvalid, with: :unprocessible_entity
        rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
        rescue_from ExceptionHandler::InvalidToken, with: :unprocessible_entity
    end

    def not_found(e)
        json_response({message: e.message}, '404')
    end

    def unauthorized_request(e)
        json_response({message: e.message}, '401')
    end

    def unprocessible_entity(e)
        json_response({message: e.message}, '422')
    end
end