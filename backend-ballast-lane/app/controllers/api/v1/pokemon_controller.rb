module Api
  module V1
    class PokemonController < BaseController
      MAX_LIMIT = 100
      DEFAULT_LIMIT = 20

      def index
        result = pokemon_service.list(
          search: params[:search],
          sort: params[:sort] || "number",
          order: params[:order] || "asc",
          limit: validated_limit,
          offset: validated_offset
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

      def validated_limit
        limit = params[:limit].to_i
        return DEFAULT_LIMIT if limit <= 0
        [limit, MAX_LIMIT].min
      end

      def validated_offset
        [params[:offset].to_i, 0].max
      end
    end
  end
end
