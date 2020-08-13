require "rails_helper"

RSpec.describe NotificationWorker, type: :worker do
  let!(:current_user) {FactoryBot.create :user}
  let!(:notification) {FactoryBot.create :notification, user_id: current_user.id}

  context "when worker perform" do
    it "should not retry" do
      is_expected.to be_retryable false
    end

    it "should enqueue another job" do
      NotificationWorker.perform_async notification.id

      expect(NotificationWorker).to have_enqueued_sidekiq_job(notification.id)
    end
  end
end
