module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from Pundit::NotAuthorizedError, with: :four_zero_three

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response( { data: { message: e.message }}, :not_found)
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    json_response( {data: { message: e.message }}, :unprocessable_entity)
  end

  def four_zero_three(e)
    json_response( {data: { message: e.message }}, 403)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    json_response( {data: { message: e.message }}, :unauthorized)
  end
end