class Api::V1::Public::SubCategoriesController < ApiController
  skip_before_action :authorize_request
  before_action :set_category
  before_action :set_category_item, only: :show

  # GET /Categorys/:Category_id/sub_categories
  def index
    payload(@category.sub_categories, ::Public::SubCategorySerializer)
  end

  # GET /Categorys/:Category_id/sub_categories/:id
  def show
    if @sub_category
      payload(@sub_category, ::Public::SubCategorySerializer)
    else
      json_response(@sub_category)
    end
  end

  private

  def sub_category_params
    params.permit(:name)
  end

  def set_category
    if params[:category_id]
      @category = Category.find(params[:category_id])
    end
  end

  def set_category_item
    @sub_category = (
      if @category
        @category.sub_categories.find_by!(id: params[:id])
      elsif params[:id]
        SubCategory.find_by!(id: params[:id])
      end
    )
  end
end
