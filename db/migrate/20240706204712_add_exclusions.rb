class AddExclusions < ActiveRecord::Migration[7.0]
  def change
    create_table :exclusions do |t|
      t.belongs_to :ability_a, polymorphic: true, null: false
      t.belongs_to :ability_b, polymorphic: true, null: false
      t.timestamps
    end
  end
end
