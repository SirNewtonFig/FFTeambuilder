class Teams::MemgenController < ApplicationController
  include HasMemgen

  before_action :load_team

  def create
    data = params[:team_files].first(15).map do |file|
      opponent = Team.new(**YAML.safe_load_file(file))

      team_a, team_b = *[@team, opponent].shuffle

      {
        team_a:,
        team_b:,
        title: "v #{opponent.name.first(14)}"
      }
    end

    generate_card(data)
  end

  private

    def load_team
      @team = Team.find(params[:team_id])
    end
end
