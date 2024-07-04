class Event < ApplicationRecord
  has_many :submissions
  belongs_to :user
  
  scope :active, -> { where(active: true) }
  scope :open, -> { where(deadline: Time.current..) }
end
