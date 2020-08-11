require "rails_helper"

RSpec.describe CampaignStatusWorker, type: :worker do
  let!(:current_user) {FactoryBot.create :user, :with_campaigns, campaign_count: 1}
  let!(:current_campaign) {current_user.campaigns.first}

  context "when worker perform" do
    it "should not retry" do
      is_expected.to be_retryable false
    end

    it "should enqueue another job" do
      CampaignStatusWorker.perform_async current_campaign.id, "pending"

      expect(CampaignStatusWorker).to have_enqueued_sidekiq_job(current_campaign.id, "pending")
    end
  end
end
