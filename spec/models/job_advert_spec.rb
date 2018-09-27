require 'rails_helper'

RSpec.describe JobAdvert, type: :model do
  let(:job_advert) {
    FactoryBot.build(:job_advert)
  }

  it "is not valid with user type candidate relation" do
    candidate = FactoryBot.create(:user, :candidate)
    job_advert.user_id = candidate.id
    expect(job_advert).to_not be_valid
  end

  it "valid with valid attributes" do 
    expect(job_advert).to be_valid
  end

  it "is not valid without a title" do
    job_advert.title = nil
    expect(job_advert).to_not be_valid
  end
end
