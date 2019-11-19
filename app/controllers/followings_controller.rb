class FollowingsController < ApplicationController
  def index
    @title = t ".title"
    @user = User.find_by id: params[:id]
    
    if @user
      @users = @user.following.page(params[:page]).per Settings.users.index.page
      render "users/show_follow"
    else 
      flash[:danger] = t ".not_found"
      redirect_to request.referrer || root_path
    end
  end
end
