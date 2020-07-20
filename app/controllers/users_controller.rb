class UsersController < ApplicationController
  before_action :logged_in_user, except: [:create, :new, :show]
  before_action :find_user, except: [:index, :create, :new]
  before_action :correct_user, only: [:edit, :update]

  def index; end

  def show
    @campaigns = @user.campaigns.ordered_campaigns.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:success] = t ".new.success_create_account"
      redirect_to login_url
    else
      flash.now[:danger] = t ".new.failed_create_account"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".edit.profile_updated"
      redirect_to @user
    else
      flash.now[:danger] = t ".edit.failed_update_profile"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".edit.user_deleted"
    else
      flash[:danger] = t ".edit.failed_delete_user"
    end

    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end
