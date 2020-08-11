class Admin::CampaignsController < AdminController
  before_action :find_campaign, only: :update

  def index
    @query = Campaign.ransack params[:q]
    @campaigns = @query.result.ordered_campaigns.page params[:page]
  end

  def update
    success = case params[:status].to_i
              when Campaign.statuses[:pending]
                @campaign.pending!
                notify_body = t "notify.campaign.pending"
              when Campaign.statuses[:running]
                @campaign.running!
                notify_body = t "notify.campaign.running"
              else
                @campaign.stopped!
                notify_body = t "notify.campaign.stopped"
              end

    handle_update_status success, notify_body
    redirect_to request.referer
  end

  private

  def handle_update_status success, notify_body
    if success
      flash[:success] = t ".update.success_change_status"
      CampaignStatusWorker.perform_async @campaign.id, Campaign.statuses.keys[params[:status].to_i]
      @campaign.notify_to_user(
        @campaign.user_id,
        t("notify.campaign.status_changed"),
        notify_body,
        campaign_url(id: @campaign.id)
      )
    else
      flash[:error] = t ".update.failed_change_status"
    end
  end
end
