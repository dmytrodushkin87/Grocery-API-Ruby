require 'rails_helper'

RSpec.describe "Api::V1::Public::Categories", type: :request do

  # initialize test data
  let!(:categories) { create_list(:category, 10) }
  let(:category_id) { categories.first.id }
  let(:sub_categories) { create(:sub_category, category_id: category_id)}
  let!(:user) { create(:user) }
  let(:headers) { valid_headers(user) }
  let(:invalid_headers) { { 'Authorization' => nil } }

  # Test suite for GET /api/v1/public/categories
  describe 'GET /api/v1/public/categories' do
    # make HTTP get request before each example
    before { get '/api/v1/public/categories' }

    it 'returns categories' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/v1/public/categories/:id
  describe 'GET /api/v1/public/categories/:id' do
    before { get "/api/v1/public/categories/#{category_id}" }

    context 'when the record exists' do
      it 'returns the category' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(category_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:category_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Category/)
      end
    end

    context 'when the expand is given' do
      before {
        sub_categories
        get "/api/v1/public/categories/#{category_id}?expand=sub_categories"
      }
      it 'returns the category' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(category_id)
        expect(json['sub_categories'][0]['id']).to eq(sub_categories.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

end
