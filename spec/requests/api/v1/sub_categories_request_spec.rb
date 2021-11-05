require 'rails_helper'

RSpec.describe "Api:;V1::SubCategories", type: :request do
   # Initialize the test data
  let!(:category) { create(:category) }
  let!(:sub_categories) { create_list(:sub_category, 20, category_id: category.id) }
  let(:category_id) { category.id }
  let(:id) { sub_categories.first.id }
  let!(:user) { create(:user) }
  let(:headers) { valid_headers(user) }
  let(:invalid_headers) { { 'Authorization' => nil } }

  # Test suite for GET /api/v1/categories/:category_id/sub_categories
  describe 'GET /api/v1/categories/:category_id/sub_categories' do
    before { get "/api/v1/categories/#{category_id}/sub_categories", headers: headers }

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

  # Test suite for GET /api/v1/categories/:category_id/sub_categories/:id
  describe 'GET /api/v1/categories/:category_id/sub_categories/:id' do
    before { get "/api/v1/categories/#{category_id}/sub_categories/#{id}" , headers: headers}

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

  describe 'GET /api/v1/sub_categories/:id' do
    before { get "/api/v1/sub_categories/#{id}" , headers: headers}

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

  # Test suite for PUT /api/v1/categories/:category_id/sub_categories
  describe 'POST /api/v1/categories/:category_id/sub_categories' do
    let(:valid_attributes) { { name: 'Visit Narnia' }.to_json }

    context 'when request attributes are valid' do
      before { post "/api/v1/categories/#{category_id}/sub_categories", params: valid_attributes , headers: headers}

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/api/v1/categories/#{category_id}/sub_categories", params: {} , headers: headers}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /api/v1/categories/:category_id/sub_categories/:id
  describe 'PUT /api/v1/categories/:category_id/sub_categories/:id' do
    let(:valid_attributes) { { name: 'Mozart' }.to_json }

    before { put "/api/v1/categories/#{category_id}/sub_categories/#{id}", params: valid_attributes , headers: headers}

    context 'when sub_category exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end

      it 'updates the sub_category' do
        updated_sub_category = SubCategory.find(id)
        expect(updated_sub_category.name).to match(/Mozart/)
      end
    end

    context 'when the sub_category does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find SubCategory/)
      end
    end
  end

  # Test suite for DELETE /api/v1/categories/:id
  describe 'DELETE /api/v1/categories/:id' do
    before { delete "/api/v1/categories/#{category_id}/sub_categories/#{id}" , headers: headers}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
