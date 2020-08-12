class CampaignsController < ApplicationController
  before_action :find_campaign, except: [:index, :create, :new]
  after_action :build_tags, only: [:new, :edit]

  load_and_authorize_resource

  def index
    @query = Campaign.ransack params[:q]
    @campaigns = @query.result
                       .includes(:user)
                       .not_pending
                       .ordered_and_paginated params[:page]
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
      flash.now[:error] = t ".failed_created"
      render :new
    end
  end

  def show
    @donations = @campaign.donations.includes(:user)
    @donations_paged = @donations.ordered_and_paginated params[:page]
    @current_donations = @donations.filter_by_creator_id current_user.id if user_signed_in?

    @comments = @campaign.comments
                         .includes(:user)
                         .ordered_and_paginated params[:page]

    @new_comment = Comment.new
  end

  def edit; end

  def update
    if @campaign.update campaign_params
      flash[:success] = t ".success_updated"
      CampaignStatusWorker.perform_async @campaign.id, Settings.campaign.types[1]
      redirect_to @campaign
    else
      flash.now[:error] = t ".failed_updated"
      render :edit
    end
  end

  def destroy
    if @campaigns.destroy
      flash[:success] = t ".success_deleted"
    else
      flash[:error] = t ".failed_deleted"
    end

    redirect_to root_url
  end

  private

  def campaign_params
    params.require(:campaign).permit Campaign::PERMIT_ATTRIBUTES
  end

  def correct_user
    @campaigns = current_user.campaigns.find_by id: params[:id]
    redirect_to root_url unless @campaigns || current_user.admin?
  end

  def build_tags
    @campaign.tags.build
  end
end
