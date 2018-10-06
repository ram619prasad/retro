class User < ApplicationRecord
    # encrypt password
    has_secure_password

    validates_presence_of :email
    validates_uniqueness_of :email
end
