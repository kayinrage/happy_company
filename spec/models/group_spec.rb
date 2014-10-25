require 'rails_helper'

describe Group do
  it 'has valid factory' do
    expect(build(:group)).to be_valid
  end

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:parent_group_id) }
  it { should validate_uniqueness_of(:name) }

  describe '#to_s' do
    let(:group) { create(:parent_group, name: 'Selleo') }

    it 'should returns name of group' do
      expect(group.to_s).to eq 'Selleo'
    end
  end
end
