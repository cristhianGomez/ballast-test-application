import Image from "next/image";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import type { Pokemon } from "@/types/pokemon";

interface PokemonCardProps {
  pokemon: Pokemon;
}

const typeColors: Record<string, string> = {
  normal: "bg-gray-400",
  fire: "bg-orange-500",
  water: "bg-blue-500",
  electric: "bg-yellow-400",
  grass: "bg-green-500",
  ice: "bg-cyan-400",
  fighting: "bg-red-600",
  poison: "bg-purple-500",
  ground: "bg-amber-600",
  flying: "bg-indigo-400",
  psychic: "bg-pink-500",
  bug: "bg-lime-500",
  rock: "bg-stone-500",
  ghost: "bg-violet-600",
  dragon: "bg-indigo-600",
  dark: "bg-gray-700",
  steel: "bg-slate-400",
  fairy: "bg-pink-400",
};

export function PokemonCard({ pokemon }: PokemonCardProps) {
  const imageUrl =
    pokemon.sprites?.official_artwork ||
    pokemon.sprites?.front_default ||
    `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png`;

  return (
    <a href={`/pokemon/${pokemon.id}`}>
      <Card className="transition-all hover:shadow-lg hover:scale-105">
        <CardHeader className="pb-2">
          <div className="flex items-center justify-between">
            <CardTitle className="text-lg capitalize">{pokemon.name}</CardTitle>
            <span className="text-sm text-muted-foreground">#{pokemon.id}</span>
          </div>
        </CardHeader>
        <CardContent>
          <div className="relative aspect-square w-full">
            <Image
              src={imageUrl}
              alt={pokemon.name}
              fill
              className="object-contain"
              sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
              priority={pokemon.id <= 20}
            />
          </div>
          <div className="mt-4 flex flex-wrap gap-2">
            {pokemon.types.map((type) => (
              <span
                key={type}
                className={`rounded-full px-3 py-1 text-xs font-medium text-white ${
                  typeColors[type] || "bg-gray-500"
                }`}
              >
                {type}
              </span>
            ))}
          </div>
        </CardContent>
      </Card>
    </a>
  );
}
