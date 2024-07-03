class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def discord
    @user = User.from_omniauth(request.env["omniauth.auth"])

    sign_in(@user)

    redirect_to after_sign_in_path_for(@user)
  end
end
