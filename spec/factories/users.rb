FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    name { 'test' }
    sequence(:email) { |n| "test#{n}@exmaple.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
