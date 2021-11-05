class AuthenticationController < ApiController
  skip_before_action :authorize_request, only: :authenticate
  # return auth token once user is authenticated
  def authenticate
    auth_token =
      AuthenticateUser.new(auth_params[:mobile_number], auth_params[:password]).call
    json_response({data: auth_token})
  end

  private

  def auth_params
    params.permit(:mobile_number, :password)
  end
end