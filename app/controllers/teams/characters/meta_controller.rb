class Teams::Characters::MetaController < ApplicationController
  before_action :load_character

  def index
    render layout: 'modal'
  end

  def update
    raise 'unauthorized' unless @team.mine?
    
    @char.data.merge!(meta_params)
    
    @team.data[i] = @char.data
    @team.save
  end

  private

    def load_character
      @team = Team.find(params[:team_id])
      @char = @team.characters[params[:character_id].to_i]
    end


    def meta_params
      params.require(:character).permit(:name, :brave, :faith, :zodiac).to_h
    end

    helper_method def i
      params[:character_id].to_i
    end
end
