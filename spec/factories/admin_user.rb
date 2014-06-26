FactoryGirl.define do
  factory :admin_user do
    sequence(:email) { |n| "admin#{n}@happycompany.com" }
    password 'secret'
    password_confirmation 'secret'
  end
end
