class Admin::CampaignsController < AdminController
  before_action :logged_in_user,
                :check_logged_user_admin,
                only: [:index, :update]
  before_action :filter_campaign, only: :index
  before_action :find_campaign, only: :update

  def index
    @campaigns = @campaigns.ordered_campaigns.page params[:page]
  end

  def update
    success = case params[:status].to_i
              when Campaign.statuses[:pending]
                @campaign.pending!
              when Campaign.statuses[:running]
                @campaign.running!
              else
                @campaign.stopped!
              end

    if success
      flash[:success] = t ".success_change_status"
    else
      flash[:error] = t ".failed_change_status"
    end

    redirect_to request.referer
  end

  private

  def filter_campaign
    @campaigns = Campaign.eager_load(:user)
                         .filter_by_title(params[:title])
                         .filter_by_desc(params[:desc])
                         .filter_by_status(params[:status])
                         .filter_by_creator(params[:creator])
  end
end
