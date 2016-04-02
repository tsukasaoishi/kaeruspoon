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
    return @current_user if defined?(@current_user)

    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user = nil
    end
  end

  helper_method :current_user, :logged_in?
end
