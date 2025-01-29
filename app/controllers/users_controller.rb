class UsersController < ApplicationController
  def destroy
    current_user.destroy

    sign_out current_user

    redirect_to new_user_session_path
  end

  def confirm_destroy
    render layout: 'modal_neutral'
  end

  def challonge_connect
    render layout: 'modal_neutral'
  end
end
