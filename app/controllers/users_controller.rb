class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_user, only: %i(show edit update)

  load_and_authorize_resource

  def show
    usr_camps = @user.campaigns
    @campaigns = {
      all: usr_camps,
      pending: usr_camps.pending,
      running: usr_camps.running,
      stopped: usr_camps.stopped
    }
    @campaigns.each do |key, val|
      @campaigns[key] = val.ordered_and_paginated params["page_#{key}"]
    end
  end

  def edit; end

  def update
    if @user.update user_params
      @user.avatar.attach user_params[:avatar] unless @user.avatar.attached?

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
    redirect_to root_url unless current_user_or_admin? @user
  end
end
