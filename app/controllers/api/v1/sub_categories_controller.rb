module Api::V1
  class SubCategoriesController < ApiController
    before_action :set_category
    before_action :set_category_item, only: [:show, :update, :destroy]

    # GET /Categorys/:Category_id/sub_categories
    def index
      payload(@category.sub_categories, SubCategorySerializer)
    end

    # GET /Categorys/:Category_id/sub_categories/:id
    def show
      if @sub_category
        payload(@sub_category, SubCategorySerializer)
      else
        json_response(@sub_category)
      end
    end

    # POST /Categorys/:Category_id/sub_categories
    def create
      sub_category = @category.sub_categories.create!(sub_category_params)
      payload(sub_category, SubCategorySerializer, status: :created)
    end

    # PUT /Categorys/:Category_id/sub_categories/:id
    def update
      @sub_category.update(sub_category_params)
      payload(@sub_category, SubCategorySerializer, status: 200)
    end

    # DELETE /Categorys/:Category_id/sub_categories/:id
    def destroy
      @sub_category.destroy
      head :no_content
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
end
