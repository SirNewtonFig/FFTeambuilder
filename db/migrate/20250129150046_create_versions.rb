class CreateVersions < ActiveRecord::Migration[7.0]
  TEXT_BYTES = 1_073_741_823

  def change
    create_table :versions do |t|
      t.bigint   :whodunnit
      t.datetime :created_at
      t.bigint   :item_id,   null: false
      t.string   :item_type, null: false
      t.string   :event,     null: false
      t.text     :object, limit: TEXT_BYTES
    end
    add_index :versions, %i[item_type item_id]
  end
end
