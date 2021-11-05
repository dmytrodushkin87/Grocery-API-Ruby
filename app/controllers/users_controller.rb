class UsersController < ApiController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.mobile_number, user.password).call
    json_response({data: auth_token.merge!(message: Message.account_created)}, :created)
  end

  private

  def user_params
    params.permit(
      :first_name,
      :last_name,
      :mobile_number,
      :email,
      :password,
      :password_confirmation
    )
  end
end
