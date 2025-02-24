class EventsController < ApplicationController
  include HasSubmissions

  def new
    @event = Event.new(deadline: Time.current.end_of_day)

    render layout: 'modal_neutral'
  end

  def edit
    @event = Event.find(params[:id])

    raise 'unauthorized' unless @event.mine?

    render layout: 'modal_neutral'
  end

  def create
    @event = Event.new(event_params)

    @event.update(user: current_user)

    @events = Event.active.order(:deadline)
  end

  def update
    @event = Event.find(params[:id])

    raise 'unauthorized' unless @event.mine?

    @event.update(event_params)

    redirect_to event_path(@event)
  end

  def show
    @event = Event.find(params[:id])

    load_submissions

    return unless turbo_frame?
  end

  def confirm_destroy
    @event = Event.find(params[:id])

    raise 'unauthorized' unless @event.mine?

    render layout: 'modal_neutral'
  end

  def destroy
    @event = Event.find(params[:id])

    raise 'unauthorized' unless @event.mine?

    @event.destroy

    redirect_to dashboard_path
  end

  def publish
    @event = Event.find(params[:id])

    raise 'unauthorized' unless @event.mine?

    Event::Publish.perform(event: @event)

    redirect_to event_path(@event)
  end

  def shuffle
    @event = Event.find(params[:id])

    raise 'unauthorized' unless @event.mine?

    Event::ShuffleBracket.perform(event: @event)

    redirect_to event_path(@event)
  end

  def start
    @event = Event.find(params[:id])

    raise 'unauthorized' unless @event.mine?

    Event::Open.perform(event: @event)

    redirect_to event_path(@event)
  end

  def close
    @event = Event.find(params[:id])

    raise 'unauthorized' unless @event.mine?

    Event::Finalize.perform(event: @event)

    redirect_to dashboard_path
  end

  def archive
    @event = Event.find(params[:id])

    raise 'unauthorized' unless @event.mine?

    @event.update(active: false)

    redirect_to dashboard_path
  end

  def memgen
    @event = Event.find(params[:id])
  end

  private

    def event_params
      params.require(:event).permit(:title, :deadline, :active, :description, :slug)
    end
end
