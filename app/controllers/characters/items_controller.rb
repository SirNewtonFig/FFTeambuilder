class Characters::ItemsController < ApplicationController
  before_action :load_character

  def index
    @items = hands? ? Item.send(scope, @char) : Item.send(scope)

    @items = @items.proficient(@char).order(:id)

    render layout: 'modal'
  end

  def update
    @char.data.merge!(equip_params)
    @char.enforce_constraints!
    
    @team.data[i] = @char.data
    @team.save
  end

  private

    helper_method def scope
      params[:scope] if %w{ rhand lhand helmet armor accessory }.include?(params[:scope])
    end

    def hands?
      ['rhand', 'lhand'].include?(scope)
    end

    def load_character
      @team = Team.find_or_initialize_by(user_id: session[:user_id])
      @char = @team.characters[params[:character_id].to_i]
    end


    def equip_params
      params.require(:character).permit(:rhand, :lhand, :helmet, :armor, :accessory).to_h
    end

    def i
      params[:character_id].to_i
    end
end
