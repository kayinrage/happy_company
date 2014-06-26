require 'spec_helper'

describe AdminUser do
  it 'has valid factory' do
    build(:admin_user).should be_valid
  end

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should_not allow_value('error.p').for(:email) }

  it { should validate_presence_of(:password) }
  it { should validate_confirmation_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6).is_at_most(128) }
end
