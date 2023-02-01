class Characters::SkillsController < ApplicationController
  before_action :load_character

  def index
    render layout: 'modal'
  end

  def update
    @refresh_secondary = secondary_changed?
    @char.data.deep_merge!(skill_params)
    @char.enforce_constraints!
    
    @team.data[i] = @char.data
    @team.save
  end

  private

    def load_character
      @team = Team.find_or_initialize_by(user_id: session[:user_id])
      @char = @team.characters[params[:character_id].to_i]
    end


    def skill_params
      params[:character] ||= {}

      x = params[:character].permit(:secondary, :reaction, :support, :movement, skills: {}).to_h

      if secondary_changed?
        x['skills'] ||= {}
        x['skills']['secondary'] = []
      end

      x
    end

    def secondary_changed?
      (secondary = params.dig(:character, :secondary)).present? && secondary.to_i != @char.data['secondary'].to_i
    end

    helper_method def i
      params[:character_id].to_i
    end
end
