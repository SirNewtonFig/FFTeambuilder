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

  private

    def load_team
      @team = Team.find_or_initialize_by(user_id: session[:user_id])
    end

    def character_params
      x = params.require(:character).permit(:job, :sex, :secondary).to_h

      if x.key?('job') && x['job'] == @char.data['secondary']
        primary = @char.data.dig('skills', 'primary')
        secondary = @char.data.dig('skills', 'secondary')

        x.merge!({
          'secondary' => @char.data['job'],
          'job' => @char.data['secondary'],
          'skills' => {
            'primary' => secondary,
            'secondary' => primary
          }
        })
      end

      x
    end

    def i
      params[:id].to_i
    end
end
