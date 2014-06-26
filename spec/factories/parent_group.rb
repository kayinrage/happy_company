FactoryGirl.define do
  factory :parent_group do
    sequence(:name) { |n| "parent_group_name_#{n}" }
  end
end
