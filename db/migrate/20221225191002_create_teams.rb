class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.uuid :user_id, nil: false
      t.text :name
      t.text :player_name
      t.integer :palette_a, default: 0
      t.integer :palette_b, default: 0
      t.jsonb :data
      t.timestamps
    end
  end
end
