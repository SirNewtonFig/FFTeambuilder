class CreateSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :submissions do |t|
      t.belongs_to :event
      t.jsonb :data
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
