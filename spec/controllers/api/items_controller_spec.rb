require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
  describe 'GET #index' do
    it 'returns an empty array initially' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe 'POST #create' do
    it 'creates an item and returns it' do
      post :create, params: { name: 'Test Item' }
      expect(response).to have_http_status(:created)
      item = JSON.parse(response.body)
      expect(item['id']).to be_present
      expect(item['name']).to eq('Test Item')
    end
  end

  describe 'GET #show' do
    it 'returns the item if found' do
      post :create, params: { name: 'Test Item' }
      item = JSON.parse(response.body)
      get :show, params: { id: item['id'] }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq('Test Item')
    end

    it 'returns 404 if not found' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH #update' do
    it 'updates the item if found' do
      post :create, params: { name: 'Old Name' }
      item = JSON.parse(response.body)
      patch :update, params: { id: item['id'], name: 'New Name' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq('New Name')
    end

    it 'returns 404 if not found' do
      patch :update, params: { id: 999, name: 'Does not exist' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the item if found' do
      post :create, params: { name: 'To Delete' }
      item = JSON.parse(response.body)
      delete :destroy, params: { id: item['id'] }
      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 if not found' do
      delete :destroy, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end
end 