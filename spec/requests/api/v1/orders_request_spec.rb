require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user_id: user.id)}
  let(:product) { create(:product)}
  let(:orders) { create_list(:order, 20, cart_id: cart.id) }
  let(:cart_id) { cart.id }
  let(:id) { orders.first.id }
  let(:loser) { create(:user)}
  let(:headers) { valid_headers(user) }
  let(:invalid_headers) { valid_headers(loser) }

  # Test suite for GET /api/v1/carts/:cart_id/orders
  context "when user is authorized" do
    before(:each) do
      orders
    end
    describe 'GET /api/v1/carts/:cart_id/orders' do
      before { get "/api/v1/carts/#{cart_id}/orders?expand=products", headers: headers }

      context 'when order exists' do
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns all carts' do
          expect(json.size).to eq(20)
        end
      end

      context 'when order does not exist' do
        let(:cart_id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Cart/)
        end
      end
    end

    # Test suite for POST /api/v1/carts/:user_id/orders
    describe 'POST /api/v1/carts/:cart_id/orders' do
      let(:valid_attributes) { { product_id: product.id, quantity: 1 }.to_json }
      let(:invalid_attributes) { { product_id: product.id}.to_json }
      let(:invalid_attributes_2) { { product_id: orders.first.product.id, quantity: 1}.to_json }
      context 'when request attributes are valid' do
        before { post "/api/v1/carts/#{cart_id}/orders" ,params: valid_attributes, headers: headers}

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'returns the created order' do
          expect(json['quantity']).to eq(1)
        end
      end

      context 'when request attributes are invalid' do
        before { post "/api/v1/carts/#{cart_id}/orders" ,params: invalid_attributes, headers: headers}

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to match(/Validation failed: Quantity can't be blank/)
        end
      end

      context 'when product id are repeated' do
        before { post "/api/v1/carts/#{cart_id}/orders" ,params: invalid_attributes_2, headers: headers}

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to match(/Validation failed: Product has already been taken/)
        end
      end
    end
  end

  describe 'GET /api/v1/orders/:id' do
    before { get "/api/v1/orders/#{id}" , headers: headers}

    context 'when cart exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the sub_category' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when order does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Order/)
      end
    end
  end

  describe 'PUT /api/v1/orders/:id' do
    let(:valid_attributes) { { quantity: '5' }.to_json }

    before { put "/api/v1/orders/#{id}", params: valid_attributes , headers: headers}

    context 'when cart exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end

      it 'updates the order' do
        order = Order.find(id)
        expect(order.quantity).to eql(5)
      end
    end

    context 'when the order does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Order/)
      end
    end
  end

  # Test suite for DELETE /api/v1/categories/:id
  describe 'DELETE /api/v1/orders/:id' do
    before { delete "/api/v1/orders/#{id}" , headers: headers}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  context "when unauthorized" do
    before(:each) do
      loser
    end
    # Test suite for GET /api/v1/categories
    describe 'GET /api/v1/carts/:cart_id/orders' do
      # make HTTP get request before each example
      before {
        get "/api/v1/carts/#{cart_id}/orders" , headers: invalid_headers
      }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    describe 'POST /api/v1/carts/:cart_id/orders' do
      # make HTTP get request before each example
      before {
        post "/api/v1/carts/#{cart_id}/orders" , headers: invalid_headers
      }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    describe 'PUT /api/v1/carts/:cart_id/orders' do
      # make HTTP get request before each example
      let(:valid_attributes) { { quantity: '5' }.to_json }
      before {
        put "/api/v1/orders/#{id}" , params: valid_attributes, headers: invalid_headers
      }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    describe 'PATCH /api/v1/carts/:cart_id/orders' do
      # make HTTP get request before each example
      let(:valid_attributes) { { quantity: '5' }.to_json }
      before {
        patch "/api/v1/orders/#{id}" , params: valid_attributes, headers: invalid_headers
      }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    describe 'DELETE /api/v1/carts/:cart_id/orders' do
      # make HTTP get request before each example
      before {
        delete "/api/v1/orders/#{id}" , headers: invalid_headers
      }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end
end
