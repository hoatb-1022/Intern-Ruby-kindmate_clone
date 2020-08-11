class CampaignStatusWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform campaign_id, status
    @campaign = Campaign.find_by id: campaign_id
    return unless @campaign

    donations = @campaign.donations.by_user_distinct
    donations.each do |donation|
      CampaignMailer.status_changed(@campaign, donation, status).deliver_now
    end
  end
end
