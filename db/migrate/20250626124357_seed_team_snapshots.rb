class SeedTeamSnapshots < ActiveRecord::Migration[7.1]
  def up
    Submission.all.each do |submission|
      next unless submission.event&.deadline&.past?

      team = Team.find_by(id: submission.team_id) || nil

      submission.destroy and next if team.nil? && submission.event_id != 8

      snapshot = TeamSnapshot.create(team.attributes.except('id'))

      submission.update(team_snapshot: snapshot)
    end

    change_column_null :submissions, :team_snapshot_id, false
  end

  def down
    change_column_null :submissions, :team_snapshot_id, true
  end
end
