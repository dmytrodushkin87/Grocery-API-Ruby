require 'rails_helper'

RSpec.describe "Api::V1::Public::SubCategories", type: :request do

  let!(:category) { create(:category) }
  let!(:sub_categories) { create_list(:sub_category, 20, category_id: category.id) }
  let(:category_id) { category.id }
  let(:id) { sub_categories.first.id }
  let!(:user) { create(:user) }
  let(:headers) { valid_headers(user) }
  let(:invalid_headers) { { 'Authorization' => nil } }

  # Test suite for GET /api/v1/public/categories/:category_id/sub_categories
  describe 'GET /api/v1/public/categories/:category_id/sub_categories' do
    before { get "/api/v1/public/categories/#{category_id}/sub_categories" }

    context 'when category exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all category sub_categories' do
        expect(json.size).to eq(20)
      end
    end

    context 'when category does not exist' do
      let(:category_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Category/)
      end
    end
  end

  # Test suite for GET /api/v1/public/categories/:category_id/sub_categories/:id
  describe 'GET /api/v1/public/categories/:category_id/sub_categories/:id' do
    before { get "/api/v1/public/categories/#{category_id}/sub_categories/#{id}" }

    context 'when category sub_category exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the sub_category' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when category sub_category does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find SubCategory/)
      end
    end
  end

   # Test suite for GET /api/v1/public/sub_categories/:id
  describe 'GET /api/v1/public/categories/:category_id/sub_categories/:id' do
    before { get "/api/v1/public/sub_categories/#{id}" }

    context 'when category sub_category exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the sub_category' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when category sub_category does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find SubCategory/)
      end
    end
  end
end
