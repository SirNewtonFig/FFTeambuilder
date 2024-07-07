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

  def destroy
    load_submission

    redirect_to event_path(@event) and return unless can_manage_submission?(@team)

    @submission.destroy
  end

  def approve
    load_submission

    redirect_to event_path(@event) and return unless can_manage_submission?(@team)

    @submission.update(approved: true)

    load_submissions
  end

  def cut
    load_submission

    redirect_to event_path(@event) and return unless can_manage_submission?(@team)

    @submission.update(approved: false)

    load_submissions
  end

  private

    def load_event
      @event = Event.find(params[:event_id])
    end

    def load_submission
      @team = Team.find(params[:id])
      @submission = Submission.find_by(event_id: @event.id, team_id: @team.id)
    end

    def load_submissions
      @submissions = Team.joins(:events).where(events: {id: @event.id }).where(submissions: { approved: nil })
      @bracket = Team.joins(:events).where(events: {id: @event.id }).where(submissions: { approved: true })
      @cut_submissions = Team.joins(:events).where(events: {id: @event.id }).where(submissions: { approved: false })
    
      @my_submissions = Team.joins(:events)
        .where(events: { id: @event.id }, teams: { user_id: Current.user.id })
    end

    def can_manage_submission?(team)
      [@event.user_id, team.user_id].include?(Current.user.id)
    end
end
