class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.text :title
      t.datetime :deadline
      t.jsonb :data, null: false, default: {}
      t.boolean :active, null: false, default: true
      t.belongs_to :user, type: :uuid
      t.timestamps
    end
  end
end
