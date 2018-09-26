FactoryGirl.define do
  factory :user do
    email "prueba@prueba.com"
    password "1234"
    
    trait :user_company do
      rol "company"
    end

    trait :user_candidate do
      rol "candidate"
    end
  end
end