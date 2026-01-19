class PokemonSyncService
  POKEAPI_BASE_URL = "https://pokeapi.co/api/v2".freeze
  BATCH_SIZE = 50

  def initialize
    @client = Faraday.new(url: POKEAPI_BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.options.timeout = 30
    end
  end

  def sync_all(limit: 151)
    Rails.logger.info "[PokemonSync] Starting sync of #{limit} Pokemon"

    (1..limit).each_slice(BATCH_SIZE) do |batch|
      batch.each do |number|
        sync_pokemon(number)
      rescue StandardError => e
        Rails.logger.error "[PokemonSync] Failed to sync Pokemon ##{number}: #{e.message}"
      end
    end

    Rails.logger.info "[PokemonSync] Sync completed. Total: #{Pokemon.count}"
  end

  private

  def sync_pokemon(number)
    pokemon_data = fetch_pokemon(number)
    return unless pokemon_data

    species_data = fetch_species(number)

    Pokemon.upsert(
      build_attributes(pokemon_data, species_data),
      unique_by: :number
    )
  end

  def fetch_pokemon(number)
    response = @client.get("pokemon/#{number}")
    return nil unless response.success?

    JSON.parse(response.body)
  rescue Faraday::Error, JSON::ParserError => e
    Rails.logger.warn "[PokemonSync] API error for ##{number}: #{e.message}"
    nil
  end

  def fetch_species(number)
    response = @client.get("pokemon-species/#{number}")
    return nil unless response.success?

    JSON.parse(response.body)
  rescue Faraday::Error, JSON::ParserError
    nil
  end

  def build_attributes(pokemon_data, species_data)
    {
      name: pokemon_data["name"],
      number: pokemon_data["id"],
      image: extract_image(pokemon_data),
      types: extract_types(pokemon_data),
      weight: pokemon_data["weight"],
      height: pokemon_data["height"],
      description: extract_description(species_data),
      color: species_data&.dig("color", "name"),
      base_stats: extract_base_stats(pokemon_data),
      moves: extract_moves(pokemon_data),
      created_at: Time.current,
      updated_at: Time.current
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

    english_entry&.dig("flavor_text")&.gsub(/\s+/, " ")&.strip
  end

  def extract_moves(data)
    moves = data["moves"] || []
    moves.map do |move_data|
      {
        name: move_data.dig("move", "name")&.tr("-", " ")&.titleize,
        learn_method: extract_learn_method(move_data),
        level_learned_at: extract_level_learned(move_data)
      }
    end.compact.uniq { |m| m[:name] }.first(20)
  end

  def extract_learn_method(move_data)
    version_details = move_data["version_group_details"]&.last
    version_details&.dig("move_learn_method", "name")&.tr("-", " ")&.titleize
  end

  def extract_level_learned(move_data)
    version_details = move_data["version_group_details"]&.last
    version_details&.dig("level_learned_at") || 0
  end
end
