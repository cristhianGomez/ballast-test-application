import { PokemonCard } from "./pokemon-card";
import type { Pokemon } from "@/types/pokemon";

interface PokemonListProps {
  pokemon: Pokemon[];
}

export function PokemonList({ pokemon }: PokemonListProps) {
  return (
    <div className="grid gap-6 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
      {pokemon.map((p) => (
        <PokemonCard key={p.id} pokemon={p} />
      ))}
    </div>
  );
}
