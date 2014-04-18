class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def required_login
    redirect_to new_session_path unless logged_in?
  end

  def logged_in?
    !current_user.guest?
  end

  def current_user
    @current_user ||= session[:user_id] ? User.find(session[:user_id]) : User.guest
  end

  helper_method :current_user, :logged_in?
end
