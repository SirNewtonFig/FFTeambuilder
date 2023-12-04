class CreateSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :submissions do |t|
      t.belongs_to :event
      t.belongs_to :team
      t.jsonb :data, null: false, default: {}
      t.boolean :active, default: true
      t.boolean :approved
      t.timestamps
    end
  end
end
