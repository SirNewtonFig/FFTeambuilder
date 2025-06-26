class TeamSnapshot < Team
  self.table_name = 'team_snapshots'

  private

    def cache_jp
      # no-op
    end
end