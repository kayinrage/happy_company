require 'faker'

FactoryGirl.define do
  factory :group do |f|
    f.name { Faker::Lorem.words(2) }
    f.parent_group_id { FactoryGirl.create(:parent_group).id }
  end
end