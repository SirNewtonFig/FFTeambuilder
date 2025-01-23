class EventsController < ApplicationController
  include HasSubmissions
  before_action :authenticate_user!, except: [:show]

  def new
    @event = Event.new(deadline: Time.current.end_of_day)

    render layout: 'modal_neutral'
  end

  def edit
    @event = Event.find(params[:id])

    raise 'unauthorized' unless @event.user == Current.user

    render layout: 'modal_neutral'
  end

  def create
    @event = Event.new(params.require(:event).permit(:title, :deadline, :active))

    @event.update(user: current_user)

    @events = Event.active.open.order(:deadline)
  end

  def update
    @event = Event.find(params[:id])

    @event.update(params.require(:event).permit(:title, :deadline, :active))

    redirect_to event_path(@event)
  end

  def show
    @event = Event.find(params[:id])

    load_submissions
  end

  def confirm_destroy
    @event = Event.find(params[:id])

    render layout: 'modal_neutral'
  end

  def destroy
    @event = Event.find(params[:id])

    @event.destroy

    redirect_to dashboard_path
  end
end
