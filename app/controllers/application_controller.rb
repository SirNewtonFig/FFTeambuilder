class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :bypass_auth?
  protect_from_forgery

  include CurrentValues

  def after_sign_in_path_for(...)
    dashboard_path
  end

  def after_sign_out_path_for(...)
    new_user_session_path    
  end

  private

    def bypass_auth?
      devise_controller? || session[:guest_id].present?
    end
end
