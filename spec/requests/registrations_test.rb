require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do
  let(:url) { '/signup' }
  let(:params) do
    {
      user: {
        email: 'user@example.com',
        password: 'password',
        rol: 'candidate'
      }
    }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }

    it 'returns 200' do
      expect(response.status).to eq 200
    end
    
    it 'returns a new user' do
      expect(JSON.parse(response.body).keys).to eq(["id", "email", "created_at", "updated_at", "rol"])
    end
  end

  context 'when user already exists' do
    before do
      User.create(email: 'usuario@example.com', password: 'password', rol: 'candidate')
      post url, params: {email: 'usuario@example.com', password: 'password', rol: 'candidate'}
    end

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end

    it 'returns validation errors' do
      expect(JSON.parse(response.body)['errors'].first['title']).to eq('Bad Request')
    end
  end
end