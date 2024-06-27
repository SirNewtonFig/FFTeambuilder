class AddMonsterPassives < ActiveRecord::Migration[7.0]
  def change
    create_table :monster_passives do |t|
      t.text :name
      t.integer :jp_cost
      t.jsonb :data
      t.belongs_to :job
      t.timestamps
    end
  end
end
