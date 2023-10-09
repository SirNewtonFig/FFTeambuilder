class Characters::JobController < ApplicationController
  before_action :load_character

  def edit
    @jobs = Job.valid(@char).order(:id)

    render layout: 'modal'
  end

  def update
    @char.data.merge!(job_params)
    puts job_params.inspect
    @char.enforce_constraints!

    @team.data[i] = @char.data
    @team.save
  end

  private

    def load_character
      @team = Team.find_or_initialize_by(user_id: session[:user_id])
      @char = @team.characters[params[:character_id].to_i]
    end

    def load_jobs
      return Job.generic if @char.generic?

      Job.monster
    end

    def job_params
      x = params.require(:character).permit(:job).to_h

      if x.key?('job') && x['job'] == @char.data['secondary']
        primary = @char.data.dig('skills', 'primary')
        secondary = @char.data.dig('skills', 'secondary')

        x = {
          'secondary' => @char.data['job'],
          'job' => @char.data['secondary'],
          'skills' => {
            'primary' => secondary,
            'secondary' => primary
          }
        }
      end

      x
    end

    helper_method def i
      params[:character_id].to_i
    end
end
