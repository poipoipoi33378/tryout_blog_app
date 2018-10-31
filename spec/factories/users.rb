FactoryBot.define do
  factory :user do
    name 'tester'
    sequence(:email) { |n| "tester#{n}@example.com" }
    password 'foobar'
  end
end
