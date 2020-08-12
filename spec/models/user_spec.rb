require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) {FactoryBot.build :user}
  let!(:user_fail) {FactoryBot.build :user, name: nil}

  describe "Validations" do
    context "when all required fields given" do
      it "should be true" do
        expect(user.valid?).to eq true
      end
    end

    context "when missing required fields" do
      it "should be false" do
        expect(user_fail.valid?).to eq false
      end
    end
  end

  describe "Associations" do
    it "should has many campaigns" do
      is_expected.to have_many(:campaigns).dependent(:destroy)
    end

    it "should has many donations" do
      is_expected.to have_many(:donations).dependent(:destroy)
    end

    it "should has many comments" do
      is_expected.to have_many(:comments).dependent(:destroy)
    end
  end

  describe "Enums" do
    context "when role has user and admin" do
      it "should be true" do
        is_expected.to define_enum_for(:role).with_values([:user, :admin])
      end
    end
  end
end
