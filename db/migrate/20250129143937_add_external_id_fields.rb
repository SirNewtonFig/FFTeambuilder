class AddExternalIdFields < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :external_id, :integer
    add_column :submissions, :external_id, :integer
    add_column :events, :bracket_url, :text

    reversible do |dir|
      dir.up do
        connection.execute <<~SQL.squish
          update events set external_id = (data ->> 'challonge_tournament_id')::int where data ->> 'challonge_tournament_id' is not null
        SQL

        connection.execute <<~SQL.squish
          update events set bracket_url = (data ->> 'live_bracket') where data ->> 'live_bracket' is not null
        SQL

        connection.execute <<~SQL.squish
          update submissions set external_id = (data ->> 'challonge_player_id')::int where data ->> 'challonge_player_id' is not null
        SQL
      end
    end
  end
end