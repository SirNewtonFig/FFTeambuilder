class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!, unless: :bypass_auth?
  before_action :set_current_values, unless: :devise_controller?

  def after_sign_in_path_for(...)
    dashboard_path
  end

  def after_sign_out_path_for(...)
    new_user_session_path    
  end

  def set_current_values
    Current.user = if current_user.present?
      current_user
    elsif session[:guest_id].present?
      User.guest(session[:guest_id])
    end

    Current.team = Team.find_by(id: session[:current_team_id]) if session[:current_team_id].present?
  end

  private

    def bypass_auth?
      devise_controller? || session[:guest_id].present?
    end
end
