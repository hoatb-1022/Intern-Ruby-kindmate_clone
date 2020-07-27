class CampaignsController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :find_campaign, except: [:index, :create, :new]
  before_action :correct_user,
                only: [:edit, :update, :destroy],
                unless: :current_user_admin?

  def index
    @campaigns = Campaign.not_pending
                         .filter_by_title_or_desc(params[:keyword])
                         .ordered_campaigns
                         .page params[:page]
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
    @donations = @campaign.donations
                          .ordered_donations
                          .includes(:user)
                          .page params[:page]
    @comments = @campaign.comments
                         .ordered_comments
                         .includes(:user)
                         .page params[:page]
    @new_comment = Comment.new
  end

  def edit; end

  def update
    if @campaign.update campaign_params
      flash[:success] = t ".success_updated"
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
    redirect_to root_url unless @campaigns
  end
end
