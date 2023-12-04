class Submission < ApplicationRecord
  belongs_to :event
  
  scope :active, -> { where(active: true) }

  def team
    Team.new(**data)    
  end
end
