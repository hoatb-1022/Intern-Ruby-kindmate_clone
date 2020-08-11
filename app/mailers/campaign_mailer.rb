class CampaignMailer < ApplicationMailer
  def status_changed campaign, donation, status
    @campaign = campaign
    @user = donation.user
    @status = status
    mail to: @user.email, subject: t("campaign_mailer.campaign_#{@status}.subject")
  end
end
