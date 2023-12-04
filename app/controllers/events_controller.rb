class EventsController < ApplicationController
  def index
    @events = Event.active
  end
end
