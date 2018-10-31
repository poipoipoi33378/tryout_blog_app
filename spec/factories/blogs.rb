FactoryBot.define do
  factory :blog do
    sequence(:title){|n| "title#{n}"}

    association :user

    trait :with_user do
      after(:create) do |blog|
        blog.user.save
      end
    end
  end
end
