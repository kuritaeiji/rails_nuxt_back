FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    sequence(:email) { |n| "test#{n}@exmaple.com" }
    name { 'test' }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
  end
end
