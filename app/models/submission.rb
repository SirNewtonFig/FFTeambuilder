class Submission < ApplicationRecord
  belongs_to :event
  belongs_to :team

  validates :team, :event, presence: true
  
  scope :active, -> { where(active: true) }

  def display_name
    player_name_override || team.player_name
  end

  def team
    t = super

    return t if t.present?

    PaperTrail::Version.where(item_id: team_id, item_type: 'Team').last.reify.paper_trail.version_at(event.deadline)
  end
end
