class EventsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.new(deadline: Time.current.end_of_day)

    render layout: 'modal_neutral'
  end

  def create
    @event = Event.new(params.require(:event).permit(:title, :deadline, :active))

    @event.update(user: current_user)

    @events = Event.active.open.order(:deadline)
  end

  def show
    @event = Event.find(params[:id])
  end
end