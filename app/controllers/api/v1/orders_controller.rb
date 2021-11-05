class Api::V1::OrdersController < ApiController
  before_action :set_cart, only: [:index, :create]
  before_action :set_order, only: [:show, :update, :destroy]

  def index
    authorize @cart, :read?
    payload(@cart.orders, OrderSerializer)
  end

  def create
    order = @cart.orders.new(order_params)
    authorize order, :create?
    order.save!
    payload(order, OrderSerializer, status: :created)
  end

  # GET /orders/:id
  def show
    if @order
      authorize @order, :read?
      payload(@order, OrderSerializer)
    else
      json_response(@order)
    end
  end

  # PUT /orders/:id
  def update
    if @order
      authorize @order, :update?
      @order.update(order_params)
      payload(@order, OrderSerializer, status: 200)
    else
      json_response(@order)
    end
  end

  # DELETE /orders/:id
  def destroy
    authorize @order, :destroy?
    @order.destroy
    head :no_content
  end

  private

  def order_params
    params.permit(:product_id, :quantity)
  end

  def set_cart
    if params[:cart_id]
      @cart = Cart.find(params[:cart_id])
    end
  end

  def set_order
    @order = Order.find_by!(id: params[:id])
  end
end
