class Api::V1::UsersController < ApiController
  before_action :set_user, only: [:show, :update, :destroy]

    # GET /users/:id
    def show
      if @user
        payload(@user, UserSerializer)
      else
        json_response(@user)
      end
    end

    # PUT /users/:id
    def update
      @user.update(user_params)
      payload(@user, UserSerializer, status: 200)
    end

    # DELETE /categories/:id
    def destroy
      @user.destroy
      head :no_content
    end

    private

    def user_params
      # whitelist params
      params.permit(:first_name, :last_name, :email, :address_line_1, :latitiude, :longitude, :city, :provice,
        :postal_code, :country, :mobile_number, :date_of_birth, :new_email, :new_mobile_number, :whatsapp_mobile_number )
    end

    def set_user
      @user = User.find(params[:id])
    end
end
