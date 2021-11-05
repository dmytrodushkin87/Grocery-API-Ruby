class AuthenticateUser
  def initialize(mobile_number, password)
    @mobile_number = mobile_number
    @password = password
  end

  # Service entry point
  def call
    if user
      {
        auth_token: JsonWebToken.encode(user_id: user.id),
        link: {
          rel: :self,
          href: "#{Settings.base_url}/api/v1/users/#{user.id}"
        }
      }
    end
  end

  private

  attr_reader :mobile_number, :password

  # verify user credentials
  def user
    user = User.find_by(mobile_number: mobile_number)
    return user if user && user.authenticate(password)
    # raise Authentication error if credentials are invalid
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end