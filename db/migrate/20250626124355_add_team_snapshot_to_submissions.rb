class AddTeamSnapshotToSubmissions < ActiveRecord::Migration[7.1]
  def change
    add_reference :submissions, :team_snapshot, null: true, foreign_key: true
  end
end
