module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        render json: {
          success: true,
          message: "Logged in successfully.",
          data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }, status: :ok
      end

      def respond_to_on_destroy
        if current_user
          render json: {
            success: true,
            message: "Logged out successfully."
          }, status: :ok
        else
          render json: {
            success: false,
            message: "Could not log out."
          }, status: :unauthorized
        end
      end
    end
  end
end
