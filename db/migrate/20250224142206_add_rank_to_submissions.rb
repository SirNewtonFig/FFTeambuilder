class AddRankToSubmissions < ActiveRecord::Migration[7.1]
  def change
    add_column :submissions, :rank, :integer
  end
end
