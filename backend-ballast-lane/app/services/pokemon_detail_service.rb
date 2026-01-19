class PokemonDetailService
  POKEAPI_BASE_URL = "https://pokeapi.co/api/v2".freeze
  CACHE_TTL = 5.minutes

  def initialize
    @client = Faraday.new(url: POKEAPI_BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

  def find(id_or_name)
    cache_key = "pokemon_detail_#{id_or_name}"

    Rails.cache.fetch(cache_key, expires_in: CACHE_TTL) do
      pokemon_data = fetch_pokemon(id_or_name)
      return nil unless pokemon_data

      species_data = fetch_species(id_or_name)

      build_response(pokemon_data, species_data)
    end
  end

  private

  def fetch_pokemon(id_or_name)
    response = @client.get("pokemon/#{id_or_name}")
    return nil unless response.success?

    JSON.parse(response.body)
  rescue Faraday::Error, JSON::ParserError
    nil
  end

  def fetch_species(id_or_name)
    response = @client.get("pokemon-species/#{id_or_name}")
    return nil unless response.success?

    JSON.parse(response.body)
  rescue Faraday::Error, JSON::ParserError
    nil
  end

  def build_response(pokemon_data, species_data)
    {
      name: pokemon_data["name"],
      number: pokemon_data["id"],
      image: extract_image(pokemon_data),
      types: extract_types(pokemon_data),
      weight: pokemon_data["weight"],
      height: pokemon_data["height"],
      description: extract_description(species_data),
      base_stats: extract_base_stats(pokemon_data),
      color: extract_color(species_data)
    }
  end

  def extract_image(data)
    data.dig("sprites", "other", "official-artwork", "front_default") ||
      data.dig("sprites", "front_default")
  end

  def extract_types(data)
    data["types"]&.map { |t| t.dig("type", "name") } || []
  end

  def extract_base_stats(data)
    stats = data["stats"] || []
    {
      hp: find_stat(stats, "hp"),
      attack: find_stat(stats, "attack"),
      defense: find_stat(stats, "defense"),
      special_attack: find_stat(stats, "special-attack"),
      special_defense: find_stat(stats, "special-defense"),
      speed: find_stat(stats, "speed")
    }
  end

  def find_stat(stats, name)
    stats.find { |s| s.dig("stat", "name") == name }&.dig("base_stat") || 0
  end

  def extract_description(species_data)
    return nil unless species_data

    english_entry = species_data["flavor_text_entries"]&.find do |entry|
      entry.dig("language", "name") == "en"
    end

    return nil unless english_entry

    english_entry["flavor_text"]
      &.gsub(/\s+/, " ")
      &.strip
  end

  def extract_color(species_data)
    species_data&.dig("color", "name")
  end
end
