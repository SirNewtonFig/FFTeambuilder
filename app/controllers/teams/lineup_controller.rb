class Teams::LineupController < ApplicationController
  def update
    @team = Team.find(params[:team_id])

    raise 'unauthorized' unless @team.mine?

    new_lineup = params[:chars].map{|i| @team.data[i.to_i] }

    @team.update(data: new_lineup)

    @index = params[:chars].index(params[:index])
    @reload_src = request.referer.match?(/submissions/) ? submission_character_path(submission_id: @team.id, id: @index) : edit_team_character_path(team_id: @team.id, id: @index)
  end
end
