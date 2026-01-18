module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: {
            success: true,
            message: "Signed up successfully.",
            data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
          }, status: :created
        else
          render json: {
            success: false,
            message: "Sign up failed.",
            errors: resource.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
