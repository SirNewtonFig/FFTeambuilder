class Characters::AiValuesController < ApplicationController
  before_action :load_character

  def update
    @char.data.deep_merge!(ai_params)
    
    @team.data[i] = @char.data
    @team.save
  end

  def clear
    @char.data.deep_merge!('ai_values' => Character::AI_VALUES.keys.map{|key| [key.parameterize, 0] }.to_h)
    
    @team.data[i] = @char.data
    @team.save
  end

  def default
    @char.data.deep_merge!('ai_values' => Character::AI_VALUES.transform_keys(&:parameterize))
    
    @team.data[i] = @char.data
    @team.save
  end

  private

    def load_character
      @team = Team.find_or_initialize_by(user_id: session[:user_id])
      @char = @team.characters[params[:character_id].to_i]
    end

    def ai_params
      params[:character].permit(ai_values: {}).to_h
    end

    helper_method def i
      params[:character_id].to_i
    end
end
