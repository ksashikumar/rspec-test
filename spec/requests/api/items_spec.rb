require 'rails_helper'

RSpec.describe 'Api::Items', type: :request do
  describe 'GET /api/items' do
    it 'returns an empty array initially' do
      get '/api/items'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe 'POST /api/items' do
    it 'creates an item' do
      post '/api/items', params: { name: 'Test Item' }
      expect(response).to have_http_status(:created)
      item = JSON.parse(response.body)
      expect(item['id']).to be_present
      expect(item['name']).to eq('Test Item')
    end
  end

  describe 'GET /api/items/:id' do
    it 'returns the item if found' do
      post '/api/items', params: { name: 'Test Item' }
      item = JSON.parse(response.body)
      get "/api/items/#{item['id']}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq('Test Item')
    end

    it 'returns 404 if not found' do
      get '/api/items/999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH /api/items/:id' do
    it 'updates the item if found' do
      post '/api/items', params: { name: 'Old Name' }
      item = JSON.parse(response.body)
      patch "/api/items/#{item['id']}", params: { name: 'New Name' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq('New Name')
    end

    it 'returns 404 if not found' do
      patch '/api/items/999', params: { name: 'Does not exist' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/items/:id' do
    it 'deletes the item if found' do
      post '/api/items', params: { name: 'To Delete' }
      item = JSON.parse(response.body)
      delete "/api/items/#{item['id']}"
      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 if not found' do
      delete '/api/items/999'
      expect(response).to have_http_status(:not_found)
    end
  end
end 