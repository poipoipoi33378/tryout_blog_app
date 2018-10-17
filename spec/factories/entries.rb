FactoryBot.define do
  factory :entry do
    sequence(:title){|n| "entry title#{n}"}
    sequence(:body){|n| "entry body#{n}"}
  end
end
