class ApplicationController < ActionController::Base
  before_action :create_session!

  def create_session!
    session[:user_id] ||= SecureRandom.uuid
  end
end
