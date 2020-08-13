class NotificationsController < ApplicationController
  before_action :check_logged_in_user, only: [:index, :update]
  before_action :format_params_date, only: :index
  before_action :find_notification, only: :update

  def index
    @query = current_user.notifications.ransack @query_params
    @notifications = @query.result
                           .includes(:user)
                           .ordered_and_paginated params[:page]
  end

  def update
    if @notification.update is_viewed: true
      redirect_to @notification.target
    else
      flash[:error] = t ".failed_change_viewed"
    end
  end

  def view_all
    ActiveRecord::Base.transaction do
      current_user.notifications.each do |notification|
        unless notification.update is_viewed: true
          flash[:error] = t ".update.failed_change_viewed"
          raise ActiveRecord::Rollback
        end
      end

      redirect_to request.referer
    end
  end

  private

  def notification_params
    params.require(:comment).permit Notification::PERMIT_ATTRIBUTES
  end

  def find_notification
    @notification = Notification.find_by id: params[:id]
    return if @notification

    flash[:error] = t ".not_found"
    redirect_to root_url
  end
end
