class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated 
        log_in user
        params[:session][:remember_me] == Settings.controllers.sessions.params ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t ".message"
        redirect_to root_url
      end
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
