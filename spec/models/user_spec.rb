require 'spec_helper'

describe User do

  it "has valid factory" do
    build(:user).should be_valid
  end

  context "user will not be created" do
    context "when email" do
      it "is missing" do
        build(:user, email: nil).should_not be_valid
      end

      it "is invalid" do
        build(:user, email: "error.pl").should_not be_valid
      end

      it "is duplicated" do
        create(:user, email: "eric@happycomapny.com").should be_valid
        build(:user, email: "eric@happycomapny.com").should_not be_valid
      end
    end

    context "when password" do
      it "is missing" do
        build(:user, password: nil, password_confirmation: nil).should_not be_valid
      end

      it "is too short" do
        build(:user, password: "1", password_confirmation: "1").should_not be_valid
      end

      it "miss match confirmation" do
        build(:user, password: "secret", password_confirmation: "secretError").should_not be_valid
      end
    end

  end

  context "when user successfully created" do
    it "sends email with confirmation after creation" do
      expect { create(:user) }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    context "when skip_confirmation is enabled" do
      it "doesn't send email with confirmation" do
        expect { create(:user, skip_email_confirmation: 1) }.to change(ActionMailer::Base.deliveries, :count).by(0)
      end
    end

    it "has created answer for current_day after creation" do
      user = create(:user)
      expect(user.answers.first.date).to eq(Date.today)
    end

  end

end