class AddTeamSnapshotsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :team_snapshots do |t|
      t.uuid :user_id
      t.text :name
      t.text :player_name
      t.integer :palette_a, default: 0
      t.integer :palette_b, default: 0
      t.jsonb :data
      t.integer :jp_total, default: 0
      t.timestamps
    end
  end
end
