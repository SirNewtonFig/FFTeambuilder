class CreateMonsterSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :monster_skills do |t|
      t.text :name
      t.jsonb :data
      t.boolean :monster_skill

      t.timestamps
    end
  end
end
