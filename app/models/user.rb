class User < ApplicationRecord
    # encrypt password
    has_secure_password

    # Associations
    has_many :boards, dependent: :destroy

    # Validations
    validates_presence_of :email
    validates_uniqueness_of :email
end
