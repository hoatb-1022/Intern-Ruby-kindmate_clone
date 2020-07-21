class CampaignsController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :find_campaign, except: [:index, :create, :new]
  before_action :correct_user, only: [:edit, :update, :destroy]

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

  def show
    @donations = @campaign.donations.page params[:page]
  end

  def edit; end

  def update
    if @campaign.update campaign_params
      flash[:success] = t ".success_updated"
      redirect_to @campaign
    else
      flash.now[:danger] = t ".failed_updated"
      render :edit
    end
  end

  def destroy
    if @campaigns.destroy
      flash[:success] = t ".success_deleted"
    else
      flash.now[:danger] = t ".failed_deleted"
    end

    redirect_to root_url
  end

  private

  def campaign_params
    params.require(:campaign).permit Campaign::PERMIT_ATTRIBUTES
  end

  def find_campaign
    @campaign = Campaign.find_by id: params[:id]

    return if @campaign

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end

  def correct_user
    @campaigns = current_user.campaigns.find_by id: params[:id]
    redirect_to root_url unless @campaigns
  end
end
