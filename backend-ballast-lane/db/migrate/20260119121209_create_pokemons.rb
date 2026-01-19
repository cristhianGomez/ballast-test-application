class CreatePokemons < ActiveRecord::Migration[7.2]
  def change
    create_table :pokemons do |t|
      t.string :name, null: false
      t.integer :number, null: false
      t.string :image
      t.string :types, array: true, default: []
      t.integer :weight
      t.integer :height
      t.text :description
      t.string :color
      t.jsonb :base_stats, default: {}

      t.timestamps
    end

    add_index :pokemons, :name, unique: true
    add_index :pokemons, :number, unique: true
    add_index :pokemons, :types, using: :gin
  end
end
