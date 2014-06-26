FactoryGirl.define do
  factory :answer do
    user { FactoryGirl.create(:user) }
    result { rand(10) == 0 ? rand(4) : 1 }
  end
end
