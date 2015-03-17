class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate(params[:name], params[:password])
      reset_session
      session[:user_id] = user.id
      redirect_to manage_path
    else
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to root_url
  end
end
