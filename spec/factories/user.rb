require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.email { Faker::Internet.email }
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.password "secret"
    f.password_confirmation "secret"
  end
end