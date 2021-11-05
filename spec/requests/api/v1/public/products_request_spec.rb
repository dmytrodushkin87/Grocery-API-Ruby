require 'rails_helper'

RSpec.describe "Api::V1::Public::Products", type: :request do
   # initialize test data
  let(:sub_category) { create(:sub_category)}
  let(:sub_category_2) { create(:sub_category)}
  let(:sub_category_id) { sub_category.id }
  let(:id) { products.first.id}
  let!(:products) { create_list(:product, 20, sub_category_id: sub_category.id) }
  let!(:product_2) { create(:product, sub_category_id: sub_category_2.id)}
  let(:product_id) { products.first.id }

  describe 'GET /api/v1/public/sub_categories/:sub_category_id/products' do
    before { get "/api/v1/public/sub_categories/#{sub_category_id}/products" }

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

  # Test suite for GET /api/v1/public/products
  describe 'GET /api/v1/public/products' do
    # make HTTP get request before each example
    context "when all the products fetch is required irrespective of sub category" do
      before { get "/api/v1/public/products?order[created_at]=desc" }

      it 'returns products' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(21)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "when the products fetch is required for specific sub category" do
      before { get "/api/v1/public/products?sub_category_id=#{sub_category_2.id}" }

      it 'returns products' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
        expect(json[0]["id"]).to eq(product_2.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "when the products fetch is required for sub category array" do
      before { get "/api/v1/public/products?sub_category_id[]=#{sub_category_2.id}&sub_category_id[]=#{sub_category.id}" }

      it 'returns products' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(21)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "when the products fetch is required for sub category array" do
      before { get "/api/v1/public/products?sub_category_id=10000" }

      it 'returns status code 200' do
        expect(response).to have_http_status(404)
      end
    end
  end

  # Test suite for GET /api/v1/sub_categories/:sub_category_id/products/:id
  describe 'GET /api/v1/public/sub_categories/:sub_category_id/products/:id' do
    before { get "/api/v1/public/sub_categories/#{sub_category_id}/products/#{id}" }

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

  # Test suite for GET /api/v1/public/products/:id
  describe 'GET /api/v1/public/products/:id' do
    before { get "/api/v1/public/products/#{product_id}" }

    context 'when the record exists' do
      it 'returns the product' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(product_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:product_id) { 1000000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end

    context 'when the expand is given' do
      before {
        get "/api/v1/public/products/#{product_id}?expand=sub_category"
      }
      it 'returns the category' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(product_id)
        expect(json['sub_category']['id']).to eq(sub_category.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
