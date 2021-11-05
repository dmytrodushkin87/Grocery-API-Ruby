require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do

   # initialize test data
  let!(:user) { create(:user) }
  let(:user_id) { user.id}
  let(:headers) { valid_headers(user) }
  let(:invalid_headers) { { 'Authorization' => nil } }

  # Test suite for GET /api/v1/users/:id
  describe 'GET /api/v1/users/:id' do
    before { get "/api/v1/users/#{user_id}" , headers: headers}

    context 'when the record exists' do
      it 'returns the category' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  # Test suite for PUT /api/v1/users/:id
  describe 'PUT /api/v1/users/:id' do
    let(:valid_attributes) {
      {
        first_name: 'test',
        last_name: "test",
        address_line_1: "Maniktala",
        city: "Kolkata",
        postal_code: "700006",
        country: "India"
      }.to_json
    }

    context 'when the record exists' do
      before { put "/api/v1/users/#{user_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(json).not_to be_empty
        expect(json).to include(
          "first_name" => "test",
          "last_name" => "test",
          "address_line_1" => "Maniktala",
          "city" => "Kolkata",
          "postal_code" => "700006",
          "country" => "India"
          )
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for PATCH /api/v1/users/:id
  describe 'PATCH /api/v1/users/:id' do
    let(:valid_attributes) {
      {
        first_name: 'test',
        last_name: "test",
        address_line_1: "Maniktala",
        city: "Kolkata",
        postal_code: "700006",
        country: "India"
      }.to_json
    }

    context 'when the record exists' do
      before { put "/api/v1/users/#{user_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(json).not_to be_empty
        expect(json).to include(
          "first_name" => "test",
          "last_name" => "test",
          "address_line_1" => "Maniktala",
          "city" => "Kolkata",
          "postal_code" => "700006",
          "country" => "India"
          )
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /api/v1/users/:id
  describe 'DELETE /api/v1/users/:id' do
    before { delete "/api/v1/users/#{user_id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
      expect(User.count).to be(0)
    end
  end

  context "when unauthorized" do
    describe 'GET /api/v1/users/:id' do
      before { get "/api/v1/users/#{user_id}" , headers: invalid_headers}

      context 'when the record exists' do
        it 'returns status code 401' do
          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'PUT /api/v1/users/:id' do
      let(:valid_attributes) { { first_name: 'Shopping' }.to_json }

      context 'when the record exists' do
        before { put "/api/v1/users/#{user_id}", params: valid_attributes, headers: invalid_headers }

        it 'returns status code 401' do
          expect(response).to have_http_status(401)
        end
      end
    end

  # Test suite for DELETE /api/v1/users/:id
    describe 'DELETE /api/v1/users/:id' do
      before { delete "/api/v1/users/#{user_id}", headers: invalid_headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

end
