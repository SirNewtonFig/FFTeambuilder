class Events::SubmissionsController < ApplicationController
  include HasSubmissions

  before_action :load_event

  def index
    load_submissions
  end

  def show
    params[:external] ? load_bracket_submission : load_submission
  end

  def new
    redirect_to event_path(@event) and return unless @event.deadline.future?

    @submission = Submission.new

    @teams = Team.where(user_id: Current.user.id).where.not(id: @event.teams.pluck(:id))

    render layout: 'modal_neutral'
  end

  def create
    redirect_to event_path(@event) and return unless @event.deadline.future?

    @submission = Submission.new(params.require(:submission).permit(:team_id))
    @submission.event = @event

    @submission.save

    load_submissions
  end

  def edit
    redirect_to event_path(@event) and return unless @event.mine?

    load_submission

    render layout: 'modal_neutral'
  end

  def update
    redirect_to event_path(@event) and return unless @event.mine?

    load_submission

    @submission.update(params.require(:submission).permit(:team_name_override, :player_name_override))

    load_submissions
  end

  def destroy
    load_submission

    redirect_to event_path(@event) and return if @event.deadline.past?
    redirect_to event_path(@event) and return unless @event.mine? || @team.mine?

    @submission.destroy
  end

  def approve
    redirect_to event_path(@event) and return unless @event.mine?

    load_submission

    @submission.update(approved: true)

    load_submissions
  end

  def cut
    redirect_to event_path(@event) and return unless @event.mine?

    load_submission

    @submission.update(approved: false)

    load_submissions
  end

  def reorder
    submissions = Submission.joins(:team).where(submissions: { event_id: @event.id }, teams: { user_id: Current.user.id })

    submissions.each do |submission|
      submission.update(priority: params[:submission_ids].find_index { |id| submission.id == id.to_i })
    end

    load_submissions
  end

  def import
    redirect_to event_path(@event) and return unless @event.mine?

    params[:team_files].each do |file|
      team_attributes = YAML.safe_load_file(file)

      team = Team.create(**team_attributes)

      Submission.create(event: @event, team:)
    end

    redirect_to event_path(@event)
  end

  def download
    raise 'unauthorized' unless @event.show_bracket?

    result = Event::ExportTeams.perform(event: @event)

    send_data(result.io.read, filename: "#{@event.title} Teams.zip")
  end

  private

    def load_event
      @event = Event.find(params[:event_id])
    end

    def load_bracket_submission
      @submission = Submission.find_by(external_id: params[:id])
      @team = @submission.team
      @team = @team.paper_trail.version_at(@event.deadline) if @event.deadline.past?
    end

    def load_submission
      @submission = Submission.find(params[:id])
      @team = @submission.team
      @team = @team.paper_trail.version_at(@event.deadline) if @event.deadline.past?
    end
end
