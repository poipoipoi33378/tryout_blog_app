FactoryBot.define do
  factory :comment do
    sequence(:body){|n| "comment#{n}"}
    approved true
  end
end
