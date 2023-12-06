class CharactersController < ApplicationController
  before_action :load_team

  def edit
    @char = @team.characters[i]
  end

  def update
    @char = @team.characters[i]
    @char.data.merge!(character_params)
    @char.enforce_constraints!

    @team.data[i] = @char.data
    @team.save

    render action: :edit
  end

  def jp_summary
    @char = @team.characters[i]

    render layout: 'modal'
  end

  private

    def load_team
      @team = Team.find_or_initialize_by(user_id: session[:user_id])

      redirect_to teams_path if @team.new_record?
    end

    def character_params
      params.require(:character).permit(:sex, :secondary).to_h
    end

    def i
      params[:id].to_i
    end
end
