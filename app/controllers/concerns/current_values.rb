module CurrentValues
  extend ActiveSupport::Concern

  included do
    before_action :set_current_values, unless: :devise_controller?

    def set_current_values
      Current.user = if current_user.present?
        current_user
      elsif session[:guest_id].present?
        User.guest(session[:guest_id])
      end
  
      Current.team = Team.find_by(id: session[:current_team_id]) if session[:current_team_id].present?
    end
  end
end