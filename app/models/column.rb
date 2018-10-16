# frozen_string_literal: true

# Column Model
class Column < ApplicationRecord
  # Associations
  belongs_to :board
  belongs_to :user
  has_many :action_items, dependent: :destroy

  # Validations
  validates_presence_of :name, :hex_code
  validate :hex_code_validation

  # Scopes
  default_scope { where('deleted is not true') }
  scope :deleted, -> { where(deleted: true) }

  private

  def hex_code_validation
    return unless hex_code

    errors.add(:hex_code, 'Invalid hexcode') unless hex_code.length == 4 ||
                                                    hex_code.length == 7
  end
end
