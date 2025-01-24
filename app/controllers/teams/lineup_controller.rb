class Teams::LineupController < ApplicationController
  def update
    team = Team.find(params[:team_id])
    
    new_lineup = params[:chars].map{|i| team.data[i.to_i] }

    team.update(data: new_lineup)

    head :ok
  end

  private

    def i
      params[:character_id].to_i
    end
end
