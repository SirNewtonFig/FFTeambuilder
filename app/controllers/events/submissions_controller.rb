class Events::SubmissionsController < ApplicationController
  include HasSubmissions

  before_action :load_event

  def new
    raise 'unauthorized' and return unless @event.deadline.future?

    @submission = Submission.new

    @teams = Team.where(user_id: Current.user.id).where.not(id: @event.teams.pluck(:id))

    render layout: 'modal_neutral'
  end

  def create
    raise 'unauthorized' and return unless @event.deadline.future?

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

  def reorder
    submissions = Submission.joins(:team).where(submissions: { event_id: @event.id }, teams: { user_id: Current.user.id })

    submissions.each do |submission|
      submission.update(priority: params[:team_ids].find_index { |id| submission.team_id == id.to_i })
    end

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

    def can_manage_submission?(team)
      [@event.user_id, team.user_id].include?(Current.user.id)
    end
end
