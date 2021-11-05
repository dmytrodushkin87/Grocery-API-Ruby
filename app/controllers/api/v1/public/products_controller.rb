class Api::V1::Public::ProductsController < ApiController
  skip_before_action :authorize_request
  before_action :set_product
  before_action :set_product_item, only: :show

  # GET /products
  def index
    if @sub_category
      @products = @sub_category.products
    else
      if !request.params.empty?
        @products = fetch_filter_data(Product)
      else
        @products = Product.all
      end
    end
    payload(@products, ProductSerializer)
  end
  # GET /products/:id
  def show
    if @product
      payload(@product, ::Public::ProductSerializer)
    else
      json_response(@product)
    end
  end

  private


  def set_product
    if params[:sub_category_id] && !params[:sub_category_id].is_a?(Array)
      @sub_category = SubCategory.find(params[:sub_category_id])
    end
  end

  def set_product_item
    @product = (
      if @sub_category
        @sub_category.products.find_by!(id: params[:id])
      elsif params[:id]
        Product.find_by!(id: params[:id])
      end
    )
  end
end
