class AddMovesToPokemons < ActiveRecord::Migration[7.2]
  def change
    add_column :pokemons, :moves, :jsonb, default: []
  end
end
