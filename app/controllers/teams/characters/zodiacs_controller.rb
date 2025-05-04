class Teams::Characters::ZodiacsController < ApplicationController
  before_action :load_character

  def index
    render layout: 'modal'
  end

  def update
    raise 'unauthorized' unless @team.mine?

    @char.data.merge!(zodiac_params)

    @team.data[i] = @char.data
    @team.save
  end

  private

    def load_character
      @team = Team.find(params[:team_id])
      @char = @team.characters[params[:character_id].to_i]
    end


    def zodiac_params
      params.require(:character).permit(:zodiac).to_h
    end

    def i
      params[:character_id].to_i
    end
end
