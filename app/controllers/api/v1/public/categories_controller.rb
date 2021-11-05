class Api::V1::Public::CategoriesController < ApiController
  skip_before_action :authorize_request
  before_action :set_category, only: :show

  # GET /categories
  def index
    if !request.params.empty?
      @categories = fetch_filter_data(Category)
    else
      @categories = Category.all
    end
    payload(@categories, ::Public::CategorySerializer)
  end

  # GET /categories/:id
  def show
    if @category
      payload(@category, ::Public::CategorySerializer)
    else
      json_response(@category)
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
