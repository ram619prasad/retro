# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # Associations
  has_many :boards, dependent: :destroy
  has_many :columns, through: :boards
  has_many :action_items, through: :columns

  # Validations
  validates_presence_of :email
  validates_uniqueness_of :email
end
