module ApiResponse
  extend ActiveSupport::Concern

  private

  def render_success(data:, message: nil, meta: nil, status: :ok)
    response = { success: true, data: data }
    response[:message] = message if message.present?
    response[:meta] = meta if meta.present?
    render json: response, status: status
  end

  def render_error(message:, errors: nil, status: :unprocessable_entity)
    response = { success: false, message: message }
    response[:errors] = Array(errors) if errors.present?
    render json: response, status: status
  end

  def render_not_found(resource_name = "Resource")
    render_error(message: "#{resource_name} not found", status: :not_found)
  end

  def render_unauthorized(message = "Unauthorized")
    render_error(message: message, status: :unauthorized)
  end

  def render_service_unavailable(message = "Service temporarily unavailable")
    render_error(message: message, status: :service_unavailable)
  end
end
