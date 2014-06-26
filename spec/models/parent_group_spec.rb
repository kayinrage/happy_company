require 'spec_helper'

describe ParentGroup do
  it 'has valid factory' do
    build(:parent_group).should be_valid
  end

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  context '#destroy' do
    let!(:parent_group) { create(:parent_group, name: 'Selleo') }

    context 'when parent group has no organisation' do
      it 'should delete parent_group' do
        expect { parent_group.destroy }.to change { ParentGroup.count }.by(-1)
      end
    end

    context 'when parent group has organisation' do
      before { create(:group, parent_group: parent_group) }

      it 'should not delete parent_group' do
        expect { parent_group.destroy }.to change { ParentGroup.count }.by(0)
      end
    end
  end
end
