class Characters::ZodiacsController < ApplicationController
  before_action :load_character

  def index
    render layout: 'modal'
  end

  def update
    @char.data.merge!(zodiac_params)
    
    @team.data[i] = @char.data
    @team.save

    redirect_to edit_character_path(params[:character_id])
  end

  private

    def load_character
      @team = Team.find_or_initialize_by(user_id: session[:user_id])
      @char = @team.characters[params[:character_id].to_i]
    end


    def zodiac_params
      params.require(:character).permit(:zodiac).to_h
    end

    def i
      params[:character_id].to_i
    end
end