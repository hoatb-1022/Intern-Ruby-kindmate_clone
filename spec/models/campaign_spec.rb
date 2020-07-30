require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let!(:user) {FactoryBot.create :user}

  describe "Validations" do
    context "when all fields given" do
      let!(:campaign) {FactoryBot.create :campaign, user_id: user.id}

      it "should be true" do
        expect(campaign.valid?).to eq true
      end
    end

    context "when fields missing" do
      let!(:campaign_fail) {FactoryBot.build :campaign}

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

    it "should has many classifications" do
      is_expected.to have_many(:classifications).dependent(:destroy)
    end

    it "should has many tags through classification" do
      is_expected.to have_many(:tags).through(:classifications)
    end
  end

  describe "Nested attributes" do
    it "should accepts nested attributes for tags" do
      is_expected.to accept_nested_attributes_for(:tags).allow_destroy(true)
    end
  end

  describe "Scopes" do
    before do
      FactoryBot.create(
        :campaign,
        title: "Test campaign 1",
        description: "Test Description 1",
        status: "pending",
        user_id: user.id
      )
      FactoryBot.create(
        :campaign,
        title: "Test campaign 2",
        description: "Test Description 2",
        status: "running",
        user_id: user.id
      )
      FactoryBot.create(
        :campaign,
        title: "Test campaign 21",
        description: "Test Description 21",
        status: "stopped",
        user_id: user.id
      )
      FactoryBot.create(
        :campaign,
        title: "Test campaign 22",
        description: "Test Description 3",
        status: "running",
        user_id: user.id
      )
    end

    context "with title filtered" do
      it "should return filtered campaigns by title" do
        expect(Campaign.filter_by_title("Test").size).to eq(4)
        expect(Campaign.filter_by_title("Test campaign 2").size).to eq(3)
      end
    end

    context "with description filtered" do
      it "should return filtered campaigns by description" do
        expect(Campaign.filter_by_desc("Test Description").size).to eq(4)
        expect(Campaign.filter_by_desc("Test Description 2").size).to eq(2)
      end
    end

    context "with status filtered" do
      it "should return filtered users by status" do
        expect(Campaign.filter_by_status(1).size).to eq(2)
        expect(Campaign.filter_by_status(nil).size).to eq(4)
      end
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
