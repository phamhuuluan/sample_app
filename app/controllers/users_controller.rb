class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :correct_user, only: %i(edit update)
  before_action :load_user, only: %i(destroy update edit)

  def index
    @users = User.select(:id, :name, :email).page(params[:page]).per Settings.users.index.page
  end

  def new
    @user = User.new 
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check"
      redirect_to root_path
    else
      flash[:danger] =  t ".error"
      render :new
    end
  end

  def show 
    @user = User.find_by id: params[:id]
      
    return if @user 
    flash[:danger] =  t ".no_user"
    redirect_to root_url
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t".Profile_updated"
      redirect_to @user
    else 
      render :edit
    end
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t".logged"
    redirect_to login_url
  end
  
  def destroy
    @user = User.find_by(id: params[:id]).destroy

    if @user.destroyed?
      flash[:success] = t".user_deleted"
      redirect_to users_url
    else
      flash[:danger] =  t".not_deleted"
    end
  end 

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user?(@user)
  end

  def load_user
    @user = User.find_by id: params[:id]
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
