class DonationsController < ApplicationController
  before_action :check_logged_in_user,
                :find_campaign,
                :running_campaign,
                only: [:new, :create]
  before_action :format_params_date, only: :index

  def index
    @query = current_user.donations.ransack @query_params
    @donations = @query.result.includes(:user)
    @donations_paged = @donations.ordered_and_paginated params[:page]

    get_donations_chart_info
    get_payment_types_chart_info
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

  def get_donations_chart_info
    @donations_chart_info = {
      series: [
        {
          name: t("global.money_amount"),
          data: @donations.group_by_day(:created_at).sum(:amount)
        }
      ],
      options: {
        title: t(".index.donated_chart"),
        subtitle: t("global.group_by_date"),
        xtitle: t("global.date"),
        ytitle: t("global.money_amount")
      }
    }
  end

  def get_payment_types_chart_info
    @payment_types_chart_info = {
      series: [
        {name: t(".new.transfer"), data: @donations.transfer.size},
        {name: t(".new.payment"), data: @donations.payment.size},
        {name: t(".new.cash"), data: @donations.cash.size}
      ],
      options: {
        title: t(".index.payment_type_chart"),
        legend: "right",
        chart: {
          height: 300
        }
      }
    }
  end
end
