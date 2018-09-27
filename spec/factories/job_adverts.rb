FactoryBot.define do
  factory :job_advert do
    title { "Title" }
    description { "description offer" }
    user { User.where(rol: "company").first || association(:user, :company)}
  end
end
