class Characters::AiValuesController < ApplicationController
  before_action :load_character

  def update
    @char.data.deep_merge!(ai_params)
    
    @team.data[i] = @char.data
    @team.save

    load_statuses
  end

  def clear
    @char.data.deep_merge!('ai_values' => Status.clear_priorities)
    
    @team.data[i] = @char.data
    @team.save

    load_statuses
  end

  def default
    @char.data.deep_merge!('ai_values' => Status.default_priorities)
    
    @team.data[i] = @char.data
    @team.save

    load_statuses
  end

  private

    def load_character
      @team = Current.team
      @char = @team.characters[params[:character_id].to_i]
    end

    def load_statuses
      @statuses = Status.for_ai_values
    end

    def ai_params
      params[:character].permit(ai_values: {}).to_h
    end

    helper_method def i
      params[:character_id].to_i
    end
end
