class AddOverrideNamesToSubmissions < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :player_name_override, :text
    add_column :submissions, :team_name_override, :text
  end
end
