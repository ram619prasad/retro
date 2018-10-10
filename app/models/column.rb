class Column < ApplicationRecord
  # Associations
  belongs_to :board

  # Validations
  validates_presence_of :name, :hex_code
  validate :hex_code_validation

  private
  def hex_code_validation
    errors.add(:hex_code, "Invalid hexcode") unless hex_code && (hex_code.length == 4 || hex_code.length == 7)
  end
end
