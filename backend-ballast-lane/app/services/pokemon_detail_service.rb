class PokemonDetailService
  def find(id_or_name)
    pokemon = find_pokemon(id_or_name)
    return nil unless pokemon

    serialize_detail(pokemon)
  end

  private

  def find_pokemon(id_or_name)
    if id_or_name.to_s.match?(/^\d+$/)
      Pokemon.find_by(number: id_or_name)
    else
      Pokemon.find_by(name: id_or_name.to_s.downcase)
    end
  end

  def serialize_detail(pokemon)
    {
      name: pokemon.name,
      number: pokemon.number,
      image: pokemon.image,
      types: pokemon.types,
      weight: pokemon.weight,
      height: pokemon.height,
      description: pokemon.description,
      base_stats: pokemon.base_stats.deep_symbolize_keys,
      color: pokemon.color,
      moves: pokemon.moves || [],
      navigation: build_navigation(pokemon.number)
    }
  end

  def build_navigation(current_number)
    prev_pokemon = Pokemon.where("number < ?", current_number).order(number: :desc).first
    next_pokemon = Pokemon.where("number > ?", current_number).order(number: :asc).first

    {
      prev: prev_pokemon ? { number: prev_pokemon.number, name: prev_pokemon.name } : nil,
      next: next_pokemon ? { number: next_pokemon.number, name: next_pokemon.name } : nil
    }
  end
end
