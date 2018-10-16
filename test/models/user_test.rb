# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Associations
  should have_many(:boards).dependent(:destroy)

  # Validations
  should validate_presence_of(:email)
  should validate_presence_of(:password)
  should validate_uniqueness_of(:email)
end
