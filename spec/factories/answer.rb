require 'faker'

FactoryGirl.define do
  factory :answer do |f|
    f.user_id { FactoryGirl.create(:user).id }
    f.result { rand(10) == 0 ? rand(4) : 1 }
  end
end