class Guests::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, :set_current_values, only: :create

  def create
    session[:guest_id] ||= SecureRandom.uuid

    redirect_to teams_path
  end
end
