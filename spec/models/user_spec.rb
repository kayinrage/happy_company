require 'spec_helper'

describe User do
  it 'has valid factory' do
    build(:user).should be_valid
  end

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should_not allow_value('error.p').for(:email) }

  it { should validate_presence_of(:password) }
  it { should validate_confirmation_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6).is_at_most(128) }

  describe '.create' do
    it 'should send email with confirmation' do
      expect { create(:user) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    context 'when skip_confirmation is enabled' do
      it 'should not send email with confirmation' do
        expect { create(:user, skip_email_confirmation: 1) }.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end

  describe '#to_s' do
    let(:user) { create(:user, email: 'irek@happy.com') }

    it 'should returns email' do
      expect(user.to_s).to eq 'irek@happy.com'
    end
  end

  describe '#display_name && name (alias method)' do
    context 'when first_name and last_name are set' do
      let(:user) { create(:user, email: 'irek@happy.com', first_name: 'Irek', last_name: 'Happy') }

      it 'should returns first_name and last_name' do
        expect(user.display_name).to eq 'Irek Happy'
        expect(user.name).to eq 'Irek Happy'
      end
    end

    context 'when first_name is set but last_name not' do
      let(:user) { create(:user, email: 'irek@happy.com', first_name: 'Irek', last_name: nil) }

      it 'should return email' do
        expect(user.display_name).to eq 'irek@happy.com'
        expect(user.name).to eq 'irek@happy.com'
      end
    end

    context 'when first_name is set but last_name not' do
      let(:user) { create(:user, email: 'irek@happy.com', first_name: nil, last_name: 'Happy') }

      it 'should return email' do
        expect(user.display_name).to eq 'irek@happy.com'
        expect(user.name).to eq 'irek@happy.com'
      end
    end
  end
end
