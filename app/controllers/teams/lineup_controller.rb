class Teams::LineupController < ApplicationController
  before_action :load_team

  def update
    new_lineup = params[:chars].map{|i| @team.data[i.to_i] }

    @team.update(data: new_lineup)

    head :ok
  end

  private

    def load_team
      @team = Current.team

      redirect_to teams_path if @team.new_record?
    end

    def i
      params[:character_id].to_i
    end
end
