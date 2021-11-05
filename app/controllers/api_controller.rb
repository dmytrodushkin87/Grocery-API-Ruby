class ApiController < ActionController::API
  include Response
  include ExceptionHandler
  include Payloadable
  include Pundit

  before_action :authorize_request, :parameters
  attr_reader :current_user, :total, :page_no, :page_size, :type, :retrieved_at

  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def parameters
    request.params.delete_if { |k, v| v.blank? }
    @order = request.params.delete(:order) || {}
    @exclude = request.params.delete(:exclude) || {}
    @expand = request.params.delete(:expand)
    @page_no = request.params.delete(:page_no)
    @page_size = request.params.delete(:page_size)
    request.params.except!(:controller, :action)
  end

  def fetch_filter_data(model)
    model.where(request.params.symbolize_keys)
  end
  # move API-specific filters/logic from ApplicationController to here
end