require 'test_helper'

class JsonWebTokenTest < ActiveSupport::TestCase
    setup do
        @user = FactoryBot.create(:user)
        @exp = 1.minutes.from_now
        @secret = Rails.application.credentials.hmac[:secret]
        @payload = { user_id: @user.id }
    end
  
    context 'encode' do
        should 'encode a payload and return json_web_token' do
            assert JsonWebToken.encode(@payload)
        end
    end

    context '#decode' do
        setup do
            @token = JsonWebToken.encode(@payload)
        end

        should 'return the correct payload after decoding' do
            payload = JsonWebToken.decode(@token)
            assert_equal @user.id, payload[:user_id]
        end

        context 'ExpiredSignature Error' do
            setup do
                @expired_token = JsonWebToken.encode(@payload, 0.seconds.from_now)
            end

            should 'return raise ExceptionHandler::InvalidToken exception' do
                error = assert_raises ExceptionHandler::InvalidToken do
                    JsonWebToken.decode(@expired_token)
                end
                
                assert_equal 'Signature has expired', error.message
            end
        end
    end
end
