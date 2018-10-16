# frozen_string_literal: true

# Class which provides the facility to encode the user payload
# and to decode the api_token to get user payload.
class JsonWebToken
  HMAC_SECRET = Rails.application.credentials.hmac_secret
  # { raise "it seems you didn't configure hmac secret" }

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    # sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    HashWithIndifferentAccess.new(JWT.decode(token, HMAC_SECRET)[0])
  rescue JWT::ExpiredSignature, JWT::DecodeError => e
    raise ExceptionHandler::InvalidToken, e.message
  end
end
