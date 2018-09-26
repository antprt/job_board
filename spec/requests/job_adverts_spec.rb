require 'rails_helper'

RSpec.describe "JobAdverts", type: :request do
  let(:user_company) { FactoryBot.create(:user, :company) }
  let(:user_candidate) { FactoryBot.create(:user, :candidate) }

  let(:valid_attributes) {
    {job_advert: {title: "Title", description: "Offer description"}}
  }

  let(:invalid_attributes) {
    {job_advert: {title: "", description: "de"}}
  }

  context "Creation when user is a valid company" do
    before { 
      @token = login(user_company)
    }

    it "return 200" do
      post job_adverts_path, params: valid_attributes, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
      expect(response).to have_http_status(200)
    end

    it "return object" do
      post job_adverts_path, params: valid_attributes, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
      expect(JSON.parse(response.body).keys).to eq(["id", "title", "description", "user_id", "created_at", "updated_at"])
    end

    it "User logged is the propietary of job_advert created" do
      post job_adverts_path, params: valid_attributes, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
      expect(JSON.parse(response.body)['user_id']).to eq(user_company.id)
    end

    it "error in values return validation errors" do
      post job_adverts_path, params: invalid_attributes, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
      expect(JSON.parse(response.body)['errors'].first['title']).to eq('Bad Request')
    end

    it "creation error return 400" do 
      post job_adverts_path, params: invalid_attributes, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
      expect(response).to have_http_status(400)
    end
  end

  context "Creation error when user is invalid" do
    it "User no company return 403" do
      @token = login(user_candidate)
      post job_adverts_path, params: valid_attributes, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
      expect(response.status).to eq 403
    end
  end 

  context "GET Index when user is valid" do
    before { 
      @token = login(user_candidate)
    }

    it "return 200" do
      get job_adverts_path, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
      expect(response).to have_http_status(200)
    end

    it "return a hash of adverts" do
      get job_adverts_path, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
      expect(response).to have_http_status(200)
    end
  end

  context "GET Index when user is invalid" do
    before { 
      @token = login(user_company)
    }

    it "user unauthorized return 403" do
      get job_adverts_path, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
      expect(response).to have_http_status(403)
    end
  end
end
