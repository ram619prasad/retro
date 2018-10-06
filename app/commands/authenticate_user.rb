class AuthenticateUser
    prepend SimpleCommand

    def initialize(email, password)
        @email = email
        @password = password
    end

    def call
        JsonWebToken.encode(user_id: user.id) if user
    end


    private
    attr_accessor :email, :password

    def user
        user = User.find_by(email: email)
        raise(ActiveRecord::RecordNotFound, 'Sorry! Invalid email') unless user
        return user if user && user.authenticate(password)
        # raise Authentication error if credentials are invalid
        raise(ExceptionHandler::AuthenticationError, 'Invalid Password')
    end
end