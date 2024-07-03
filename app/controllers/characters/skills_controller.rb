class Characters::SkillsController < ApplicationController
  before_action :load_character

  def edit
    @skills = if @char.generic?
      Skill.send(scope).valid(@char).unique(@char, @team).order(:name)
    else
      @char.job.skills.send(scope)
    end

    render layout: 'modal'
  end

  def update
    @refresh_secondary = secondary_changed?
    @support_changed = support_changed?
    @movement_changed = movement_changed? 

    @char.data.deep_merge!(skill_params)

    @char.enforce_exclusions!(@support_changed)
    @char.enforce_constraints! if @support_changed || @movement_changed
    
    @team.data[i] = @char.data
    @team.save
  end

  private

    def load_character
      @team = Current.team
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

    def support_changed?
      return false unless params[:character].key?(:support)

      params.dig(:character, :support).to_i != @char.data['support'].to_i
    end

    def movement_changed?
      return false unless params[:character].key?(:movement)

      params.dig(:character, :movement).to_i != @char.data['movement'].to_i
    end

    def secondary_changed?
      return false unless params[:character].key?(:secondary)

      params.dig(:character, :secondary).to_i != @char.data['secondary'].to_i
    end

    helper_method def i
      params[:character_id].to_i
    end

    helper_method def scope
      params[:scope] if %w{ reaction support movement }.include?(params[:scope])
    end

    helper_method def scope_label
      {
        reaction: 'Reaction',
        support: 'Empower',
        movement: 'Support'
      }.with_indifferent_access[scope]
    end
end
