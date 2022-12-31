class CreateSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :skills do |t|
      t.text :value
      t.integer :jp_cost
      t.text :name
      t.integer :skill_type, default: 0
      t.jsonb :data
      t.belongs_to :job

      t.timestamps
    end

    create_table :innates do |t|
      t.belongs_to :job
      t.belongs_to :skill

      t.timestamps
    end
  end
end
