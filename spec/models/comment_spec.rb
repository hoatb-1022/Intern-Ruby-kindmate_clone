require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:user) {FactoryBot.create :user}
  let!(:campaign) {FactoryBot.create :campaign, user_id: user.id}

  describe "Validations" do
    context "when all fields given" do
      let!(:comment) {FactoryBot.create :comment, user_id: user.id, campaign_id: campaign.id}

      it "should be true" do
        expect(comment.valid?).to eq true
      end
    end

    context "when fields missing" do
      let!(:comment_fail) {FactoryBot.build :comment}

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

  describe "Delegates" do
    context "with delegate to user name" do
      it "should be true" do
        is_expected.to delegate_method(:name).to(:user).with_prefix(true).allow_nil
      end
    end

    context "with delegate to campaign id" do
      it "should be true" do
        is_expected.to delegate_method(:id).to(:campaign).with_prefix(true).allow_nil
      end
    end
  end
end
