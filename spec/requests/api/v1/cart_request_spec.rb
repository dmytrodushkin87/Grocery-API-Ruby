require 'rails_helper'

RSpec.describe "Api::V1::Carts", type: :request do

  let(:user) { create(:user) }
  let(:carts) { create_list(:cart, 20, user_id: user.id) }
  let(:user_id) { user.id }
  let(:id) { carts.first.id }
  let(:loser) { create(:user)}
  let(:headers) { valid_headers(user) }
  let(:invalid_headers) { valid_headers(loser) }
  let(:cart){ create(:cart, :pending, user_id: user.id)}

  # Test suite for GET /api/v1/users/:user_id/carts
  context "when user is authorized" do
    before(:each) do
      carts
    end
    describe 'GET /api/v1/users/:user_id/carts' do
      before { get "/api/v1/users/#{user_id}/carts", headers: headers }

      context 'when cart exists' do
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns all carts' do
          expect(json.size).to eq(20)
        end
      end

      context 'when cart does not exist' do
        let(:user_id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find User/)
        end
      end
    end

    # Test suite for PUT /api/v1/users/:user_id/carts
    describe 'POST /api/v1/users/:user_id/carts' do
      let(:valid_attributes) { { mode_of_payment: "cash" }.to_json }
      context 'when request attributes are valid' do
        before { post "/api/v1/users/#{user_id}/carts" ,params: valid_attributes, headers: headers}

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it "expect the status to be unconfirmed" do
          new_cart = Cart.last
          expect(new_cart).to have_state(:unconfirmed)
        end

        it 'returns the created order' do
          expect(json['mode_of_payment']).to eq("cash")
        end
      end
    end
  end

  describe 'GET /api/v1/carts/:id' do
    before { get "/api/v1/carts/#{id}" , headers: headers}

    context 'when cart exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the sub_category' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when category cart does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Cart/)
      end
    end
  end

  describe 'GET /api/v1/carts/:id/confirmation' do

    context 'when valid' do
      before { post "/api/v1/carts/#{cart.id}/confirmation" , headers: headers}
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the cart' do
        cart.reload
        expect(cart).to have_state(:confirmed)
      end
    end

    context 'when status cannot change' do
      before { post "/api/v1/carts/#{id}/confirmation" , headers: headers}
      it 'returns status code 200' do
        expect(response).to have_http_status(422)
      end

      it 'returns the error' do
        expect(response.body).to match(/Validation failed: Status errors.cannot_transit/)
      end
    end

    context 'when category cart does not exist' do
      before { post "/api/v1/carts/#{id}/confirmation" , headers: headers}
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Cart/)
      end
    end
  end

  describe 'PUT /api/v1/carts/:id' do
    let(:valid_attributes) { { delivery_person_name: 'Mozart' }.to_json }

    before { put "/api/v1/carts/#{id}", params: valid_attributes , headers: headers}

    context 'when cart exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end

      it 'updates the cart' do
        updated_cart = Cart.find(id)
        expect(updated_cart.delivery_person_name).to match(/Mozart/)
      end
    end

    context 'when the cart does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Cart/)
      end
    end
  end

  # Test suite for DELETE /api/v1/categories/:id
  describe 'DELETE /api/v1/carts/:id' do
    before { delete "/api/v1/carts/#{id}" , headers: headers}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  context "when unauthorized" do
    before(:each) do
      loser
    end
    # Test suite for GET /api/v1/categories
    describe 'GET /api/v1/users/:user_id/carts' do
      # make HTTP get request before each example
      before {
        get "/api/v1/users/#{user_id}/carts" , headers: invalid_headers
      }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    describe 'POST /api/v1/users/:user_id/carts' do
      # make HTTP get request before each example
      before {
        post "/api/v1/users/#{user_id}/carts" , headers: invalid_headers
      }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end
end
