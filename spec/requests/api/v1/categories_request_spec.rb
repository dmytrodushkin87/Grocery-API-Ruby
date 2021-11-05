require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do

  # initialize test data
  let!(:categories) { create_list(:category, 10) }
  let(:category_id) { categories.first.id }
  let(:sub_categories) { create(:sub_category, category_id: category_id)}
  let!(:user) { create(:user) }
  let(:headers) { valid_headers(user) }
  let(:invalid_headers) { { 'Authorization' => nil } }

  # Test suite for GET /api/v1/categories
  describe 'GET /api/v1/categories' do
    # make HTTP get request before each example
    before { get '/api/v1/categories' , headers: headers}

    it 'returns categories' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/v1/categories/:id
  describe 'GET /api/v1/categories/:id' do
    before { get "/api/v1/categories/#{category_id}" , headers: headers}

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

    context 'when the expnad is given' do
      before {
        sub_categories
        get "/api/v1/categories/#{category_id}?expand=sub_categories" , headers: headers
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

  # Test suite for POST /api/v1/categories
  describe 'POST /api/v1/categories' do
    # valid payload
    let(:valid_attributes) { { name: 'Fruits & Vegetables' }.to_json }

    context 'when the request is valid' do
      before { post '/api/v1/categories', params: valid_attributes, headers: headers }

      it 'creates a category' do
        expect(json['name']).to eq('Fruits & Vegetables')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/categories' , headers: headers}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /api/v1/categories/:id
  describe 'PUT /api/v1/categories/:id' do
    let(:valid_attributes) { { name: 'Shopping' }.to_json }

    context 'when the record exists' do
      before { put "/api/v1/categories/#{category_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(json).not_to be_empty
        expect(json).to include(
          "name" => 'Shopping')
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /api/v1/categories/:id
  describe 'DELETE /api/v1/categories/:id' do
    before { delete "/api/v1/categories/#{category_id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  context "when unauthorized" do
    # Test suite for GET /api/v1/categories
    describe 'GET /api/v1/categories' do
      # make HTTP get request before each example
      before { get '/api/v1/categories' , headers: invalid_headers}

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET /api/v1/categories/:id' do
      before { get "/api/v1/categories/#{category_id}" , headers: invalid_headers}

      context 'when the record exists' do
        it 'returns status code 401' do
          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'POST /api/v1/categories' do
    # valid payload
      let(:valid_attributes) { { name: 'Fruits & Vegetables' }.to_json }

      context 'when the request is valid' do
        before { post '/api/v1/categories', params: valid_attributes, headers: invalid_headers }

        it 'returns status code 401' do
          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'PUT /api/v1/categories/:id' do
      let(:valid_attributes) { { name: 'Shopping' }.to_json }

      context 'when the record exists' do
        before { put "/api/v1/categories/#{category_id}", params: valid_attributes, headers: invalid_headers }

        it 'returns status code 401' do
          expect(response).to have_http_status(401)
        end
      end
    end

  # Test suite for DELETE /api/v1/categories/:id
    describe 'DELETE /api/v1/categories/:id' do
      before { delete "/api/v1/categories/#{category_id}", headers: invalid_headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
