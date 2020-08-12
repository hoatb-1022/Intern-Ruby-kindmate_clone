require "rails_helper"

RSpec.describe Campaign, type: :model do
  let!(:user) {FactoryBot.create :user}

  describe "Validations" do
    context "when all fields given" do
      let(:campaign) {FactoryBot.create :campaign, user_id: user.id}

      it "should be true" do
        expect(campaign.valid?).to eq true
      end
    end

    context "when fields missing" do
      let(:campaign_fail) {FactoryBot.build :campaign}

      it "should be false" do
        expect(campaign_fail.valid?).to eq false
      end
    end
  end

  describe "Associations" do
    it "should has many donations" do
      is_expected.to have_many(:donations).dependent(:destroy)
    end

    it "should has many comments" do
      is_expected.to have_many(:comments).dependent(:destroy)
    end
  end

  describe "Delegates" do
    context "with delegate to user name and campaigns" do
      it "should be true" do
        is_expected.to delegate_method(:name).to(:user).with_prefix(true).allow_nil
        is_expected.to delegate_method(:campaigns).to(:user).with_prefix(true).allow_nil
      end
    end
  end
end
