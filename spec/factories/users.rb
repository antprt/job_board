FactoryBot.define do
  factory :user do
    password { "1234" }
    
    trait :company do
      email { "example@company.com" }
      rol { "company" }
    end

    trait :candidate do
      email { "example@candidate.com" }
      rol { "candidate" }
    end
  end
end