class DonationsController < ApplicationController
  before_action :check_logged_in_user,
                :correct_campaign,
                :running_campaign,
                only: [:new, :create]
  before_action :format_params_date, only: :index

  def index
    @query = current_user.donations.ransack @query_params
    @donations = @query.result.includes(:user)
    @donations_paged = @donations.ordered_and_paginated params[:page]
  end

  def new
    @donation = Donation.new
  end

  def create
    @donation = @campaign.donations.build donation_params

    if @donation.save
      flash[:success] = t ".success_donated"
      redirect_to @campaign
    else
      flash.now[:error] = t ".failed_donated"
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

  def running_campaign
    return if @campaign.running?

    flash[:error] = t "campaigns.not_running"
    redirect_to request.referer || root_url
  end

  def format_params_date
    queries = params[:q] || {}
    if queries[:created_at_cont].present?
      date = queries[:created_at_cont].to_date
      queries[:created_at_gteq] = date.beginning_of_day.strftime Settings.global.strftime_format
      queries[:created_at_lteq] = date.end_of_day.strftime Settings.global.strftime_format
    end

    @query_params = queries.reject{|k, _v| k == "created_at_cont"}
  end
end
