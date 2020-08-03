require 'rails_helper'

RSpec.describe Donation, type: :model do
  let!(:user) {FactoryBot.create :user}
  let!(:campaign) {FactoryBot.create :campaign, user_id: user.id}

   describe "Validations" do
    context "when all fields given" do
      let(:donations) {FactoryBot.create :donation, user_id: user.id, campaign_id: campaign.id}

      it "should be true" do
        expect(donations.valid?).to eq true
      end
    end

    context "when fields missing" do
      let(:donations_fail) {FactoryBot.build :donation}

      it "should be false" do
        expect(donations_fail.valid?).to eq false
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

  describe "Enums" do
    context "when payment type has tranfer, payment and cash" do
      it "should be true" do
        is_expected.to define_enum_for(:payment_type).with_values([:transfer, :payment, :cash])
      end
    end
  end

  describe ".generate_payment_code" do
    it "new payment code should be successfully generated" do
      expect(Donation.generate_payment_code(campaign.id).size > 0).to eq(true)
    end
  end
end
