class Api::V1::CartsController < ApiController
  before_action :set_user, only: [:index, :create]
  before_action :set_cart, only: [:show, :update, :destroy, :confirmation]

  def index
    authorize @user, :read?
    payload(@user.carts, CartSerializer)
  end

  def create
    cart = @user.carts.new(cart_params)
    authorize cart, :create?
    cart.save!
    payload(cart, CartSerializer, status: :created)
  end

  # GET /carts/:id
  def show
    if @cart
      authorize @cart, :read?
      payload(@cart, CartSerializer)
    else
      json_response(@cart)
    end
  end

  # PUT /carts/:id
  def update
    if @cart
      authorize @cart, :update?
      @cart.update(cart_params)
      payload(@cart, CartSerializer, status: 200)
    else
      json_response(@cart)
    end
  end

  # DELETE /carts/:id
  def destroy
    authorize @cart, :destroy?
    @cart.destroy
    head :no_content
  end

  def confirmation
    if @cart
      authorize @cart, :update?
      @cart.confirm
      @cart.save!
      payload(@cart, CartSerializer)
    else
      json_response(@cart)
    end
  end

  private

  def cart_params
    params.permit(:mode_of_payment, :status, :addres_line_1, :addres_line_2, :city, :postal_code, :state,
    :delivery_place, :mobile_number, :delivery_person_name, :delivery_person_mobile_number)
  end

  def set_user
    if params[:user_id]
      @user = User.find(params[:user_id])
    end
  end

   def set_cart
    @cart = Cart.find_by!(id: params[:id])
  end
end
