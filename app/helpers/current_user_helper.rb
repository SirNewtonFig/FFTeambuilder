module CurrentUserHelper
  def current_user_name
    Current.user.username
  end

  def default_team_name
    return current_user_name if Current.user.persisted?
  end
end
  