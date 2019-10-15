class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    
    if user&.authenticate params[:session][:password]
      log_in user
      params[:session][:remember_me] == Settings.controllers.sessions.params ? user.remember : user.forget
      redirect_to user
    else 
      flash.now[:danger] = t".email_pass"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url 
  end
end
