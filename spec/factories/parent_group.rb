require 'faker'

FactoryGirl.define do
  factory :parent_group do |f|
    f.name { Faker::Lorem.words(2) }
  end
end