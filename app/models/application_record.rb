# frozen_string_literal: true

# Base class for all the controllers.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
