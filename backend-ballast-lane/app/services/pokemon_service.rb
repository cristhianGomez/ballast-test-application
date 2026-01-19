class PokemonService
  def list(search: nil, sort: "number", order: "asc", limit: 20, offset: 0)
    pokemons = Pokemon
      .search_by_term(search)
      .sorted_by(sort, order)

    total_count = pokemons.count
    paginated = pokemons.offset(offset).limit(limit)

    {
      pokemon: paginated.map { |p| serialize_list_item(p) },
      meta: {
        count: total_count,
        limit: limit,
        offset: offset
      }
    }
  end

  private

  def serialize_list_item(pokemon)
    {
      name: pokemon.name,
      number: pokemon.number,
      image: pokemon.image
    }
  end
end
