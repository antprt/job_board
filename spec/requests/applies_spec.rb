require 'rails_helper'

RSpec.describe "Applies", type: :request do
  let(:user_company) { FactoryBot.create(:user, :company) }
  let(:user_candidate) { FactoryBot.create(:user, :candidate) }

  let(:valid_attributes) {
    {apply: {status: "reject", highlight: true}}
  }

  let(:invalid_attributes) {
    {apply: {status: nil, highlight: nil}}
  }

  describe "GET /applies" do 
    context "when User is a company" do
      before { 
        @token = login(user_company)
        #Creation of another user and job_adverts and applies
        user = User.create(email: "another@company.com", password: "1234", rol: "company")
        FactoryBot.create(:job_advert)
        FactoryBot.create(:job_advert)
        FactoryBot.create(:job_advert)
        job_advert = JobAdvert.create(title: "title", description: "description", user_id: user.id)
        FactoryBot.create(:apply)
        apply = Apply.create(job_advert_id: job_advert.id, user_id: user.id, status: "pending")
      }

      it "Only shows applies for job_adverts of the company" do
        get applies_path, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(JSON(response.body).map {|resource| resource["id"]}).to eq(Apply.where(job_advert_id: user_company.id).pluck(:id).uniq)
      end

      it "return 200" do 
        get applies_path, headers: {"Authorization": "#{@token}", "Accept": "application/json"} 
        expect(response).to have_http_status(200)       
      end
    end

    context "When user is a candidate" do
      before { 
        @token = login(user_candidate)
      }

      it "Return 403" do 
        get applies_path, headers: {"Authorization": "#{@token}", "Accept": "application/json"}        
        expect(response).to have_http_status(403)       
      end
    end
  end

  describe "GET /apply/:id" do
    context "When user is a company" do
      before { 
        @token = login(user_company)
        FactoryBot.create(:job_advert)
        FactoryBot.create(:apply)
      }

      it "return 200" do
        get apply_path(id: Apply.first.id), headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(response).to have_http_status(200)
      end

      it "return resource JSON" do
        get apply_path(id: Apply.first.id), headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(JSON(response.body).keys).to eq(["id", "status", "highlight", "user_id", "job_advert_id", "created_at", "updated_at"])
      end

      it "return 404 apply not found" do
        get apply_path(id: 5), headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(response).to have_http_status(404)
      end

      it "return 404 the user logged is not the owner of the apply" do 
        #Creation of another user and job_advert and apply
        company = User.create(email: "another@company.com", password: "1234", rol: "company")
        job_advert = JobAdvert.create(title: "title", description: "description", user_id: company.id)
        apply = Apply.create(job_advert_id: job_advert.id, user_id: User.where(rol: "candidate").first.id, status: "pending")

        get apply_path(id: apply.id), headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(response).to have_http_status(404)
      end
    end

    context "When user is a candidate" do
      before { 
        @token = login(user_candidate)
      }

      it "return 403" do 
        get apply_path(id: 1), headers: {"Authorization": "#{@token}", "Accept": "application/json"}        
        expect(response).to have_http_status(403)   
      end
    end
  end

  describe "POST /applies" do
    context "When user is a candidate" do
      before { 
        @token = login(user_candidate)
        FactoryBot.create(:job_advert, user: user_company)
      }

      it "Create return 200" do 
        post applies_path, params: {apply: {job_advert_id: JobAdvert.first.id }}, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(response).to have_http_status(200)   
      end

      it "Create return resource JSON" do
        post applies_path, params: {apply: {job_advert_id: JobAdvert.first.id }}, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(JSON(response.body).keys).to eq(["id", "status", "highlight", "user_id", "job_advert_id", "created_at", "updated_at"])   
      end

      it "user logged is the owner of the created resource" do
        post applies_path, params: {apply: {job_advert_id: JobAdvert.first.id }}, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(JSON(response.body)["user_id"]).to eq(user_candidate.id)   
      end
    end

    context "When user is a company" do
      it "Return 403" do 
        @token = login(user_company)
        FactoryBot.create(:job_advert, user: user_company)
        post applies_path, params: {apply: {job_advert_id: JobAdvert.first.id }}, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "PUT /apply/:id" do
    context "When user is a company" do
      before { 
        @token = login(user_company)
        job_advert = FactoryBot.create(:job_advert)
        apply = FactoryBot.create(:apply, job_advert: job_advert)
      }

      it "Update return 200" do
        put apply_path(id: Apply.first.id), params: valid_attributes, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(response).to have_http_status(200)
      end

      it "Update return resource JSON" do
        put apply_path(id: Apply.first.id), params: valid_attributes, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(JSON(response.body).keys).to eq(["status", "highlight", "id", "user_id", "job_advert_id", "created_at", "updated_at"])
      end

      it "Update the attributes pass in params" do
        put apply_path(id: Apply.first.id), params: {apply: {status: "hire"}}, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(JSON(response.body)["status"]).to eq("hire")
      end 
    end

    context "When user is a candidate" do
      it "Return 403" do 
        @token = login(user_candidate)
        job_advert = FactoryBot.create(:job_advert, user: user_company)
        apply = FactoryBot.create(:apply, job_advert: job_advert)
        put apply_path(id: apply.id), params: valid_attributes, headers: {"Authorization": "#{@token}", "Accept": "application/json"}
        expect(response).to have_http_status(403)
      end
    end
  end

end