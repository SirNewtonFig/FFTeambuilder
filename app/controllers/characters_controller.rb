class CharactersController < ApplicationController
  before_action :load_team

  def edit
    @char = @team.characters[i]
  end

  def update
    @char = @team.characters[i]

    puts character_params.inspect

    @char.data.merge!(character_params)

    puts @char.data.inspect

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
      x = { 'skills' => { 'primary' => [], 'secondary' => [] } }
        .deep_merge(params.require(:character).permit(:name, :job, :sex, :brave, :faith, :zodiac, :rhand, :lhand, :helmet, :armor, :accessory, :secondary, :reaction, :support, :movement, skills: {}).to_h)

      if x['job'] == x['secondary']
        primary = x.dig('skills', 'primary')
        secondary = x.dig('skills', 'secondary')
        primary_id = @char.data['job']
        secondary_id = @char.data['secondary']

        x.merge!({
          'secondary' => primary_id,
          'job' => secondary_id,
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
