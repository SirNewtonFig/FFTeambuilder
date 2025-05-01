class Submission < ApplicationRecord
  extend Memoist

  belongs_to :event
  belongs_to :team

  validates :team, :event, presence: true

  before_validation :set_names, on: :create

  scope :active, -> { where(active: true) }

  scope :queue_ordered, -> {
    left_joins(:team)
      .order(Arel.sql('coalesce(teams.player_name, submissions.player_name_override), submissions.priority, submissions.created_at'))
  }

  def team
    t = super

    return t if t.present? && event.open?

    return t.paper_trail.version_at(event.deadline) if t.present? && !event.open?

    PaperTrail::Version.where(item_id: team_id, item_type: 'Team').last.reify.paper_trail.version_at(event.deadline)
  end

  memoize def team_display_name
    team_name_override.presence || team.name || 'Unnamed Team'
  end

  memoize def player_display_name
    player_name_override.presence || team.player_name || 'Unknown Player'
  end

  private

    def set_names
      self.player_name_override = team.player_name
      self.team_name_override = team.name
    end
end
