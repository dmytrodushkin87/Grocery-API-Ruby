class Api::V1::OffersController < ApiController
  before_action :set_offer, only: :show

  # GET /offers
  def index
    if !request.params.empty?
      @offers = fetch_filter_data(Offer)
    else
      @offers = Offer.all
    end
    payload(@offers, OfferSerializer)
  end

  # GET /offers/:id
  def show
    if @offer
      payload(@offer, OfferSerializer)
    else
      json_response(@offer)
    end
  end

  private

  def set_offer
    @offer = Offer.find_by!(id: params[:id])
  end
end
