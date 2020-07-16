class CampaignsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def index
    @campaigns = Campaign.filtered_campaigns(
      params[:keyword]
    ).ordered_campaigns.page params[:page]
  end

  def new
    @campaign = current_user.campaigns.build
  end

  def create
    @campaign = current_user.campaigns.build campaign_params
    @campaign.image.attach campaign_params[:image]

    if @campaign.save
      flash[:success] = t ".success_created"
      redirect_to root_url
    else
      flash.now[:danger] = t ".failed_created"
      render :new
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit Campaign::PERMIT_ATTRIBUTES
  end
end
