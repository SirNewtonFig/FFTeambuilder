module CurrentValues
  extend ActiveSupport::Concern

  included do
    before_action :set_current_values, unless: :devise_controller?

    def set_current_values
      set_current_user
    end

    private

      def set_current_user
        Current.user = if current_user.present?
          current_user
        elsif session[:guest_id].present?
          User.guest(session[:guest_id])
        end
      end
  end
end