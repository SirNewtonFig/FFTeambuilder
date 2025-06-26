class Submissions::CharactersController < ApplicationController
  before_action :load_team

  def show
    @char = @team.characters[i]

    load_statuses

    render template: 'teams/characters/show'
  end

  def jp_summary
    @char = @team.characters[i]

    render layout: 'modal'
  end

  private

    def load_team
      @submission = Submission.find(params[:submission_id])
      event = @submission.event

      @team = @submission.team
    end

    def load_statuses
      @statuses = Status.for_ai_values
    end

    def i
      params[:id].to_i
    end
end
