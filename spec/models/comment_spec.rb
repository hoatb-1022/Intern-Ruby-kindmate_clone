require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "Validations" do
    context "when all fields given" do
      let(:user) {FactoryBot.create :user}
      let(:campaign) {FactoryBot.create :campaign, user_id: user.id}
      let(:comment) {FactoryBot.create :comment, user_id: user.id, campaign_id: campaign.id}

      it "should be true" do
        expect(comment.valid?).to eq true
      end
    end

    context "when fields missing" do
      let(:comment_fail) {FactoryBot.build :comment}

      it "should be false" do
        expect(comment_fail.valid?).to eq false
      end
    end
  end

  describe "Associations" do
    it "should belong to user" do
      is_expected.to belong_to(:user)
    end

    it "should belong to campaign" do
      is_expected.to belong_to(:campaign)
    end
  end
end
