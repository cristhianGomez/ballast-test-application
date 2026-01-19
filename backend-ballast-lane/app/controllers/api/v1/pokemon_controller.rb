module Api
  module V1
    class PokemonController < BaseController
      def index
        result = pokemon_service.list(
          search: params[:search],
          sort: params[:sort] || "number",
          order: params[:order] || "asc",
          limit: (params[:limit] || 20).to_i,
          offset: (params[:offset] || 0).to_i
        )

        if result
          render_success(data: result[:pokemon], meta: result[:meta])
        else
          render_service_unavailable("Failed to fetch Pokemon list")
        end
      end

      def show
        pokemon = pokemon_detail_service.find(params[:id])

        if pokemon
          render_success(data: pokemon)
        else
          render_not_found("Pokemon")
        end
      end

      private

      def pokemon_service
        @pokemon_service ||= PokemonService.new
      end

      def pokemon_detail_service
        @pokemon_detail_service ||= PokemonDetailService.new
      end
    end
  end
end
