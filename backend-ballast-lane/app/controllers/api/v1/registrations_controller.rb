module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      # Override create to skip session-based sign_in for API mode
      def create
        build_resource(sign_up_params)

        resource.save
        yield resource if block_given?

        if resource.persisted?
          # Generate JWT token for the newly registered user
          token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
          response.headers["Authorization"] = "Bearer #{token}"

          render json: {
            success: true,
            message: "Signed up successfully.",
            data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
          }, status: :created
        else
          clean_up_passwords resource
          set_minimum_password_length
          render json: {
            success: false,
            message: "Sign up failed.",
            errors: resource.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

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
