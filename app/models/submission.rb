class Submission < ApplicationRecord
  belongs_to :event
  belongs_to :team
  
  scope :active, -> { where(active: true) }
end
