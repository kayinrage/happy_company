require 'spec_helper'

describe ParentGroup do

  it "has valid factory" do
    build(:parent_group).should be_valid
  end

  context "parent group will not be created" do
    context "when name" do
      it "is missing" do
        build(:parent_group, name: nil).should_not be_valid
      end

      it "is duplicated" do
        create(:parent_group, name: "Selleo").should be_valid
        build(:parent_group, name: "Selleo").should_not be_valid
      end
    end
  end

  context "when parent group has organisation" do
    it "cannot be deleted" do
      parent_group = create(:parent_group, name: "Selleo")
      create(:group, parent_group_id: parent_group.id)
      expect { parent_group.destroy }.to change(ParentGroup, :count).by(0)
    end
  end

  context "when parent group has no organisation" do
    it "can be deleted" do
      parent_group = create(:parent_group, name: "Selleo")
      expect { parent_group.destroy }.to change(ParentGroup, :count).by(-1)
    end
  end

end