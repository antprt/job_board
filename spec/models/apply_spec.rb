require 'rails_helper'

RSpec.describe Apply, type: :model do
  let(:apply) {
    FactoryBot.build(:apply)
  }

  it "is not valid with user type company relation" do
    company = FactoryBot.create(:user, :company, email: "try@try.com")
    apply.user_id = company.id
    expect(apply).to_not be_valid
  end

  it "is not valid without a status" do
    apply.status = nil
    expect(apply).to_not be_valid
  end

  it "is not valid with duplicates pair user_id, job_advert_id" do
    FactoryBot.create(:apply)
    expect(apply).to_not be_valid
  end

  it "is valid with valid attributes" do
    expect(apply).to be_valid
  end

  it "scope return only applies for a company" do
    FactoryBot.create(:apply)
    another_company = FactoryBot.create(:user, :company, email: "try@try.com")
    job_advert = FactoryBot.create(:job_advert, user_id: another_company.id)
    FactoryBot.create(:apply, job_advert_id: job_advert.id)

    expect(Apply.job_advert_from_company(User.where(rol: "company").first)).to eq Apply.all.where(job_advert_id: User.where(rol: "company").first.job_advert.pluck(:id))
  end

end