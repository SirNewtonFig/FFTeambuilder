class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.text :title
      t.datetime :deadline
      t.jsonb :data
      t.boolean :active
      t.timestamps
    end
  end
end
