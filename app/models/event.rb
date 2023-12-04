class Event < ApplicationRecord
  has_many :submissions
  
  scope :active, -> { where(active: true) }
end
