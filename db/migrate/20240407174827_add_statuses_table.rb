class AddStatusesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :statuses do |t|
      t.text :name
      t.text :description
      t.integer :default_priority
      t.text :duration
      t.text :indicator
      t.boolean :show_priority, default: true
      t.timestamps
    end
  end
end
