require 'spec_helper'

describe AdminUser do

  it "has valid factory" do
    build(:admin_user).should be_valid
  end

  context "admin_user will not be created" do
    context "when email" do
      it "is missing" do
        build(:admin_user, email: nil).should_not be_valid
      end

      it "is invalid" do
        build(:admin_user, email: "error.pl").should_not be_valid
      end

      it "is duplicated" do
        create(:admin_user, email: "eric@happycomapny.com").should be_valid
        build(:admin_user, email: "eric@happycomapny.com").should_not be_valid
      end
    end

    context "when password" do
      it "is missing" do
        build(:admin_user, password: nil, password_confirmation: nil).should_not be_valid
      end

      it "is too short" do
        build(:admin_user, password: "1", password_confirmation: "1").should_not be_valid
      end

      it "miss match confirmation" do
        build(:admin_user, password: "secret", password_confirmation: "secretError").should_not be_valid
      end
    end

  end
end