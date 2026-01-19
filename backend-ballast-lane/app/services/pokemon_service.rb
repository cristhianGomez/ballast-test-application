class PokemonService
  POKEAPI_BASE_URL = "https://pokeapi.co/api/v2".freeze
  ALL_POKEMON_CACHE_KEY = "all_pokemon_list".freeze
  ALL_POKEMON_CACHE_TTL = 1.hour
  POKEMON_DETAIL_CACHE_TTL = 5.minutes

  def initialize
    @client = Faraday.new(url: POKEAPI_BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

  def list(search: nil, sort: "number", order: "asc", limit: 20, offset: 0)
    all_pokemon = fetch_all_pokemon
    return nil unless all_pokemon

    filtered = apply_search(all_pokemon, search)
    sorted = apply_sort(filtered, sort, order)
    paginated = sorted[offset, limit] || []

    enriched = enrich_with_images(paginated)

    {
      pokemon: enriched,
      meta: {
        count: sorted.size,
        limit: limit,
        offset: offset
      }
    }
  end

  private

  def fetch_all_pokemon
    Rails.cache.fetch(ALL_POKEMON_CACHE_KEY, expires_in: ALL_POKEMON_CACHE_TTL) do
      response = @client.get("pokemon", { limit: 100_000 })
      return nil unless response.success?

      data = JSON.parse(response.body)
      data["results"].map.with_index(1) do |pokemon, index|
        {
          name: pokemon["name"],
          number: index,
          url: pokemon["url"]
        }
      end
    end
  rescue Faraday::Error, JSON::ParserError
    nil
  end

  def apply_search(pokemon_list, search)
    return pokemon_list if search.blank?

    search_term = search.to_s.downcase.strip

    if search_term.match?(/^\d+$/)
      pokemon_list.select { |p| p[:number].to_s.include?(search_term) }
    else
      pokemon_list.select { |p| p[:name].include?(search_term) }
    end
  end

  def apply_sort(pokemon_list, sort, order)
    sorted = case sort.to_s.downcase
    when "name"
      pokemon_list.sort_by { |p| p[:name] }
    else
      pokemon_list.sort_by { |p| p[:number] }
    end

    order.to_s.downcase == "desc" ? sorted.reverse : sorted
  end

  def enrich_with_images(pokemon_list)
    pokemon_list.map do |pokemon|
      cache_key = "pokemon_image_#{pokemon[:number]}"

      image = Rails.cache.fetch(cache_key, expires_in: POKEMON_DETAIL_CACHE_TTL) do
        fetch_pokemon_image(pokemon[:number])
      end

      {
        name: pokemon[:name],
        number: pokemon[:number],
        image: image
      }
    end
  end

  def fetch_pokemon_image(id_or_name)
    response = @client.get("pokemon/#{id_or_name}")
    return nil unless response.success?

    data = JSON.parse(response.body)
    data.dig("sprites", "other", "official-artwork", "front_default") ||
      data.dig("sprites", "front_default")
  rescue Faraday::Error, JSON::ParserError
    nil
  end
end
