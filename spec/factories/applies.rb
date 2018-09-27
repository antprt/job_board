FactoryBot.define do
  factory :apply do
    status { "pending" }
    highlight { false }
    user { User.where(rol: "candidate").first || association(:user, :candidate) }
    job_advert { JobAdvert.first || association(:job_advert) }
  end
end
