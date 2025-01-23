class DashboardController < ApplicationController
  def show
    @events = Event.active.order(:deadline)
    @teams = Team.where(user_id: Current.user.id)
  end
end
