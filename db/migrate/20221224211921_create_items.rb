class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.text :name
      t.integer :item_type
      t.jsonb :data
      t.timestamps
    end

    create_table :proficiencies do |t|
      t.belongs_to :item
      t.belongs_to :record, polymorphic: true
      t.timestamps
    end
  end
end
