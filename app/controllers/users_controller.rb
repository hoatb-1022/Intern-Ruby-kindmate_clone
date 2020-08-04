class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_user
  before_action :correct_user,
                only: [:edit, :update, :destroy],
                unless: :current_user_admin?

  def show
    @campaigns = @user.campaigns.ordered_campaigns_by_donated.page params[:page]
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".edit.profile_updated"
      redirect_to @user
    else
      flash.now[:error] = t ".edit.failed_update_profile"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".edit.user_deleted"
    else
      flash[:error] = t ".edit.failed_delete_user"
    end

    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end
end
