FactoryBot.define do
  factory :user do
    email { "example@example.com" }
    password { "1234" }
    
    trait :company do
      rol { "company" }
    end

    trait :candidate do
      rol { "candidate" }
    end
  end
end