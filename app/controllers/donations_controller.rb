class DonationsController < ApplicationController
  before_action :logged_in_user, :correct_campaign, only: [:new, :create]

  def new
    @donation = Donation.new
  end

  def create
    @donation = @campaign.donations.build donation_params

    if @donation.save
      flash[:success] = t ".success_donated"
      redirect_to @campaign
    else
      flash.now[:danger] = t ".failed_donated"
      render :new
    end
  end

  private

  def donation_params
    params.require(:donation).permit(
      Donation::PERMIT_ATTRIBUTES
    ).merge donation_additional_params
  end

  def donation_additional_params
    campaign_id = params[:campaign_id]

    {
      payment_code: Donation.generate_payment_code(campaign_id),
      user_id: current_user.id
    }
  end

  def correct_campaign
    @campaign = Campaign.find_by id: params[:campaign_id]
    return if @campaign

    flash[:danger] = t "campaigns.not_found"
    redirect_to root_url
  end
end
