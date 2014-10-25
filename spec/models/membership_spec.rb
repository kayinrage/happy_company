require 'rails_helper'

describe Membership do
  it 'has valid factory' do
    expect(build(:membership)).to be_valid
  end

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:group_id) }
  it { should validate_uniqueness_of(:group_id).scoped_to(:user_id) }
end
