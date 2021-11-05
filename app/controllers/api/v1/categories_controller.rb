module Api::V1
  class CategoriesController < ApiController
    before_action :set_category, only: [:show, :update, :destroy]

    # GET /categories
    def index
      if !request.params.empty?
        @categories = fetch_filter_data(Category)
      else
        @categories = Category.all
      end
      payload(@categories, CategorySerializer)
    end

    # POST /categories
    def create
      @category = Category.create!(category_params)
      payload(@category, CategorySerializer, status: :created)
    end

    # GET /categories/:id
    def show
      if @category
        payload(@category, CategorySerializer)
      else
        json_response(@category)
      end
    end

    # PUT /categories/:id
    def update
      @category.update(category_params)
      payload(@category, CategorySerializer, status: 200)
    end

    # DELETE /categories/:id
    def destroy
      @category.destroy
      head :no_content
    end

    private

    def category_params
      # whitelist params
      params.permit(:name)
    end

    def set_category
      @category = Category.find(params[:id])
    end
  end
end
