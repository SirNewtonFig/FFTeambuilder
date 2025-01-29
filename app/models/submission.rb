class Submission < ApplicationRecord
  belongs_to :event
  belongs_to :team
  
  scope :active, -> { where(active: true) }

  def display_name
    player_name_override || team.player_name
  end
end
