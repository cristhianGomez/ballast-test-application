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
      color: pokemon.color
    }
  end
end
