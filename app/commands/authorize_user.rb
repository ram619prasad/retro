class AuthorizeUser
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    {
        user: user
    }
  end

  
  private
  attr_reader :headers

  def user
    begin
        @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    rescue ActiveRecord::RecordNotFound => e
        raise(ExceptionHandler::InvalidToken, 'Invalid Token')
    end
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers['Authorization'].present?
        return headers['Authorization'].split(' ').last
    end

    raise(ExceptionHandler::MissingToken, 'Invalid request. No Authorization token present in headers.')
  end
end