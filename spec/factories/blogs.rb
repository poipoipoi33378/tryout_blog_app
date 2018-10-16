FactoryBot.define do
  factory :blog do
    sequence(:title){|n| "title#{n}"}
  end
end
