FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "group_name_#{n}" }
    parent_group { FactoryGirl.create(:parent_group) }
  end
end
