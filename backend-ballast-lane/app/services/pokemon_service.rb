class PokemonService
  POKEAPI_BASE_URL = "https://pokeapi.co/api/v2".freeze
  CACHE_TTL = 5.minutes

  def initialize
    @client = Faraday.new(url: POKEAPI_BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

  def list(limit: 20, offset: 0)
    cache_key = "pokemon_list_#{limit}_#{offset}"

    Rails.cache.fetch(cache_key, expires_in: CACHE_TTL) do
      response = @client.get("pokemon", { limit: limit, offset: offset })
      return nil unless response.success?

      data = JSON.parse(response.body)
      pokemon_list = data["results"].map.with_index(offset + 1) do |pokemon, index|
        fetch_pokemon_details(pokemon["name"]) || build_basic_pokemon(pokemon, index)
      end

      {
        pokemon: pokemon_list.compact,
        count: data["count"],
        next: data["next"],
        previous: data["previous"]
      }
    end
  end

  def find(id_or_name)
    cache_key = "pokemon_#{id_or_name}"

    Rails.cache.fetch(cache_key, expires_in: CACHE_TTL) do
      fetch_pokemon_details(id_or_name)
    end
  end

  private

  def fetch_pokemon_details(id_or_name)
    response = @client.get("pokemon/#{id_or_name}")
    return nil unless response.success?

    data = JSON.parse(response.body)
    transform_pokemon_data(data)
  rescue Faraday::Error, JSON::ParserError
    nil
  end

  def build_basic_pokemon(pokemon, index)
    {
      id: index,
      name: pokemon["name"],
      sprites: nil,
      types: []
    }
  end

  def transform_pokemon_data(data)
    {
      id: data["id"],
      name: data["name"],
      height: data["height"],
      weight: data["weight"],
      sprites: {
        front_default: data.dig("sprites", "front_default"),
        back_default: data.dig("sprites", "back_default"),
        front_shiny: data.dig("sprites", "front_shiny"),
        official_artwork: data.dig("sprites", "other", "official-artwork", "front_default")
      },
      types: data["types"].map { |t| t.dig("type", "name") },
      abilities: data["abilities"].map { |a| a.dig("ability", "name") },
      stats: data["stats"].map do |s|
        {
          name: s.dig("stat", "name"),
          base_stat: s["base_stat"]
        }
      end
    }
  end
end
