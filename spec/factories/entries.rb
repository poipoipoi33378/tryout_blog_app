FactoryBot.define do
  factory :entry do
    sequence(:title){|n| "entry title#{n}"}
    sequence(:body){|n| "entry body#{n}"}

    trait :with_5_comments do
      after(:create){ |entry| create_list(:comment,5,entry: entry) }
    end

    association :blog
  end
end
