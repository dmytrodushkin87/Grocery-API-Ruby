class Api::V1::ProductsController < ApiController
  before_action :set_sub_category
  before_action :set_sub_category_item, only: :show

  # GET /Categorys/:Category_id/sub_categories
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

  # GET /Categorys/:Category_id/sub_categories/:id
  def show
    if @product
      payload(@product, ProductSerializer)
    else
      json_response(@product)
    end
  end

  private

  def set_sub_category
    if params[:sub_category_id]
      @sub_category = SubCategory.find(params[:sub_category_id])
    end
  end

  def set_sub_category_item
    @product = (
      if @sub_category
        @sub_category.products.find_by!(id: params[:id])
      elsif params[:id]
        Product.find_by!(id: params[:id])
      end
    )
  end
end
