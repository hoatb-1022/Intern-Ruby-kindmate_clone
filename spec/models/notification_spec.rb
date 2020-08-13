require "rails_helper"

RSpec.describe Notification, type: :model do
  let!(:user) {FactoryBot.create :user}

  describe "Validations" do
    context "when all fields given" do
      let(:notification) {FactoryBot.create :notification, user_id: user.id}

      it "should be true" do
        expect(notification.valid?).to eq true
      end
    end

    context "when fields missing" do
      let(:notification_fail) {FactoryBot.build :notification}

      it "should be false" do
        expect(notification_fail.valid?).to eq false
      end
    end
  end

  describe "Associations" do
    it "should belong to user" do
      is_expected.to belong_to(:user)
    end
  end

  describe "Scopes" do
    include_examples "create example notifications"

    context "when not viewed filtered" do
      it "should return not viewed notifications" do
        expect(Notification.not_viewed_notifications.size).to eq(3)
      end
    end

    context "for nav dropdown notifications" do
      it "should return nav dropdown notifications" do
        expect(Notification.nav_dropdown_notifications.size).to eq(Settings.notification.show_nav_dropdown)
      end
    end
  end
end
