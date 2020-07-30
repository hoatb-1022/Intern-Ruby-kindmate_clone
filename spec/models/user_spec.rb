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

  describe "Scopes" do
    include_examples "create example users"

    context "with name filtered" do
      it "should return filtered users by name" do
        expect(User.filter_by_name("Test").size).to eq(4)
        expect(User.filter_by_name("Test User").size).to eq(3)
      end
    end

    context "with email filtered" do
      it "should return filtered users by email" do
        expect(User.filter_by_email("user").size).to eq(3)
        expect(User.filter_by_email("test.com").size).to eq(4)
      end
    end

    context "with phone filtered" do
      it "should return filtered users by phone" do
        expect(User.filter_by_phone("038").size).to eq(4)
        expect(User.filter_by_phone("0385656556").size).to eq(1)
      end
    end

    context "with address filtered" do
      it "should return filtered users by address" do
        expect(User.filter_by_address("Test Address").size).to eq(4)
        expect(User.filter_by_address("Test Address 1").size).to eq(2)
      end
    end

    context "with description filtered" do
      it "should return filtered users by description" do
        expect(User.filter_by_desc("Test Description").size).to eq(4)
        expect(User.filter_by_desc("Test Description 1").size).to eq(2)
      end
    end

    context "with role filtered" do
      it "should return filtered users by role" do
        expect(User.filter_by_status(1).size).to eq(1)
        expect(User.filter_by_status(0).size).to eq(3)
      end
    end
  end

  describe ".new_token" do
    it "new token should be successfully generated" do
      expect(User.new_token.size > 0).to eq(true)
    end
  end
end
