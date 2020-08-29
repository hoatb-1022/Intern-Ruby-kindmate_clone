class Admin::CampaignsController < AdminController
  before_action :find_campaign, only: :update

  def index
    @query = Campaign.ransack params[:q]
    @campaigns = @query.result.ordered_and_paginated params[:page]
  end

  def update
    status = params[:status].to_i
    success = case status
              when Campaign.statuses[:pending]
                @campaign.pending!
                notify_body = "notifications.campaign.pending"
              when Campaign.statuses[:running]
                @campaign.running!
                notify_body = "notifications.campaign.running"
              else
                @campaign.stopped!
                notify_body = "notifications.campaign.stopped"
              end

    handle_update_status success, notify_body
    redirect_to request.referer
  end

  private

  def handle_update_status success, notify_body
    if success
      flash[:success] = t ".update.success_change_status"
      CampaignStatusWorker.perform_async @campaign.id, Campaign.statuses.keys[params[:status].to_i]
      send_notification_success notify_body
    else
      flash[:error] = t ".update.failed_change_status"
    end
  end

  def send_notification_success notify_body
    notification = @campaign.user.notifications.create(
      title: "notifications.campaign.status_changed",
      body: notify_body,
      target: campaign_url(id: @campaign.id, slug: @campaign.slug)
    )
    NotificationWorker.perform_async notification.id if notification.persisted?
  end
end
