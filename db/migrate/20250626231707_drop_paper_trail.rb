class DropPaperTrail < ActiveRecord::Migration[7.1]
  def change
    drop_table :versions
  end
end
