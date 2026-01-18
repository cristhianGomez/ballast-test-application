module Api
  module V1
    class PokemonController < BaseController
      skip_before_action :authenticate_user!

      def index
        limit = params.fetch(:limit, 20).to_i
        offset = params.fetch(:offset, 0).to_i

        result = pokemon_service.list(limit: limit, offset: offset)

        if result
          render json: {
            success: true,
            data: result[:pokemon],
            meta: {
              count: result[:count],
              limit: limit,
              offset: offset
            }
          }
        else
          render_error("Failed to fetch Pokemon list", status: :service_unavailable)
        end
      end

      def show
        pokemon = pokemon_service.find(params[:id])

        if pokemon
          render json: {
            success: true,
            data: pokemon
          }
        else
          render_error("Pokemon not found", status: :not_found)
        end
      end

      private

      def pokemon_service
        @pokemon_service ||= PokemonService.new
      end
    end
  end
end
