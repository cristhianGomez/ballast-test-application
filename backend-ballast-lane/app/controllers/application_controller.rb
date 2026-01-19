class ApplicationController < ActionController::API
  include ApiResponse

  respond_to :json

  rescue_from JWT::DecodeError, with: :handle_jwt_error
  rescue_from JWT::ExpiredSignature, with: :handle_jwt_expired

  private

  def handle_jwt_error
    render_unauthorized("Invalid token")
  end

  def handle_jwt_expired
    render_unauthorized("Token has expired")
  end
end
