require 'rails_helper'

RSpec.describe "Api::V1::Offers", type: :request do
  # initialize test data
  let!(:offers) { create_list(:offer, 10) }
  let(:offer_id) { offers.first.id }
  let!(:user) { create(:user) }
  let(:headers) { valid_headers(user) }
  let(:invalid_headers) { { 'Authorization' => nil } }

  # Test suite for GET /api/v1/offers
  describe 'GET /api/v1/offers' do
    # make HTTP get request before each example
    before { get '/api/v1/offers' , headers: headers}

    it 'returns offers' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/v1/offers/:id
  describe 'GET /api/v1/offers/:id' do
    before { get "/api/v1/offers/#{offer_id}" , headers: headers}

    context 'when the record exists' do
      it 'returns the offer' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(offer_id)
        expect(json['offer_active']).to be_falsey
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record exists' do
      let(:offer_2){ create(:offer, starts_at: Chronic.parse("yesterday"), finishes_at: Chronic.parse("tomorrow"))}
      let(:offer_id) { offer_2.id}
      it 'returns the offer with offer active true' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(offer_id)
        expect(json['offer_active']).to be_truthy
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:offer_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Offer/)
      end
    end
  end

  context "when unauthorized" do
    # Test suite for GET /api/v1/offers
    describe 'GET /api/v1/offers' do
      # make HTTP get request before each example
      before { get '/api/v1/offers' , headers: invalid_headers}

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET /api/v1/offers/:id' do
      before { get "/api/v1/offers/#{offer_id}" , headers: invalid_headers}

      context 'when the record exists' do
        it 'returns status code 401' do
          expect(response).to have_http_status(401)
        end
      end
    end
  end

end
