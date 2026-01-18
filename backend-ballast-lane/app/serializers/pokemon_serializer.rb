class PokemonSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :height, :weight, :sprites, :types, :abilities, :stats
end
