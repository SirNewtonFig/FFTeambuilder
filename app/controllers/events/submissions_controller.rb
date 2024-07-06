class Events::SubmissionsController < ApplicationController
  before_action :load_event

  def new
    @submission = Submission.new

    @teams = Team.where(user_id: Current.user.id).where.not(id: @event.teams.pluck(:id))

    render layout: 'modal_neutral'
  end

  def create
    @submission = Submission.new(params.require(:submission).permit(:team_id))
    @submission.event = @event

    @submission.save

    load_submissions
  end

  private

    def load_event
      @event = Event.find(params[:event_id])
    end

    def load_submissions
      @submissions = Team.joins(:events).where(events: {id: @event.id })
    
      @my_submissions = Team.joins(:events)
        .where(events: { id: @event.id }, teams: { user_id: Current.user.id })
    end
end
