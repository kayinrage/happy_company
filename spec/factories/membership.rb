FactoryGirl.define do
  factory :membership do
    user { FactoryGirl.create(:user) }
    group { FactoryGirl.create(:group) }
  end
end
