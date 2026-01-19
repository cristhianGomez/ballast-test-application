import { PokemonCard } from "./pokemon-card";
import type { PokemonListItem } from "@/types/pokemon";

interface PokemonListProps {
  pokemon: PokemonListItem[];
  onCardClick?: (name: string) => void;
}

export function PokemonList({ pokemon, onCardClick }: PokemonListProps) {
  return (
    <div className="grid grid-cols-[repeat(auto-fill,minmax(104px,max-content))] gap-4 justify-center p-4">
      {pokemon.map((p) => (
        <PokemonCard
          key={p.number}
          pokemon={p}
          onClick={onCardClick ? () => onCardClick(p.name) : undefined}
        />
      ))}
    </div>
  );
}
