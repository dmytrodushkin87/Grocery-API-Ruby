require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
   # Initialize the test data
  let(:sub_category) { create(:sub_category) }
  let(:sub_category_2) { create(:sub_category) }
  let!(:products) { create_list(:product, 20, sub_category_id: sub_category.id) }
  let!(:product_2) { create(:product, sub_category_id: sub_category_2.id) }
  let(:sub_category_id) { sub_category.id }
  let(:id) { products.first.id }
  let!(:user) { create(:user) }
  let(:headers) { valid_headers(user) }
  let(:invalid_headers) { { 'Authorization' => nil } }

  # Test suite for GET /api/v1/sub_categories/:sub_category_id/products
  describe 'GET /api/v1/sub_categories/:sub_category_id/products' do
    before { get "/api/v1/sub_categories/#{sub_category_id}/products", headers: headers }

    context 'when product exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all product products' do
        expect(json.size).to eq(20)
      end
    end

    context 'when product does not exist' do
      let(:sub_category_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find SubCategory/)
      end
    end
  end

  # Test suite for GET /api/v1/sub_categories/:sub_category_id/products
  describe 'GET /api/v1/products' do
    context "when no parameter is passed" do
      before { get "/api/v1/products", headers: headers }

      context 'when product exists' do
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns all product products' do
          expect(json.size).to eq(21)
        end
      end
    end

    context "when parameter is passed" do
      before { get "/api/v1/products?sub_category_id=#{sub_category_2.id}", headers: headers }

      context 'when product exists' do
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns all product products' do
          expect(json.size).to eq(1)
          expect(json[0]["id"]).to eq(product_2.id)
        end
      end
    end

    context "when different parameter is passed" do
      before { get "/api/v1/products?sub_category_id=10000000", headers: headers }

      context 'when product exists' do
        it 'returns status code 200' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  # Test suite for GET /api/v1/sub_categories/:sub_category_id/products/:id
  describe 'GET /api/v1/sub_categories/:sub_category_id/products/:id' do
    before { get "/api/v1/sub_categories/#{sub_category_id}/products/#{id}" , headers: headers}

    context 'when product sub_product exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the sub_product' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when product sub_product does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end

  describe 'GET /api/v1/products/:id' do
    before { get "/api/v1/products/#{id}" , headers: headers}

    context 'when product sub_product exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the sub_product' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when product sub_product does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end

end
