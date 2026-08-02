class AddFormatToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :format, :text, default: 'double elimination'
  end
end
