class AddDescriptionToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :description, :text
  end
end
