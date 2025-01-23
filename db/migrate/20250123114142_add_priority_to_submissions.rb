class AddPriorityToSubmissions < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :priority, :integer
  end
end
