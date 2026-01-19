"use client";

import Image from "next/image";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Skeleton } from "@/components/ui/skeleton";
import type { PokemonDetail as PokemonDetailType } from "@/types/pokemon";

interface PokemonDetailProps {
  pokemon: PokemonDetailType | null;
  isLoading: boolean;
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

const statNames: Record<string, string> = {
  hp: "HP",
  attack: "Attack",
  defense: "Defense",
  "special-attack": "Sp. Atk",
  "special-defense": "Sp. Def",
  speed: "Speed",
};

function getStatColor(value: number): string {
  if (value >= 100) return "bg-green-500";
  if (value >= 70) return "bg-lime-500";
  if (value >= 50) return "bg-yellow-500";
  if (value >= 30) return "bg-orange-500";
  return "bg-red-500";
}

export function PokemonDetailView({ pokemon, isLoading }: PokemonDetailProps) {
  if (isLoading) {
    return <PokemonDetailSkeleton />;
  }

  if (!pokemon) {
    return (
      <div className="text-center text-muted-foreground">
        Pokemon not found
      </div>
    );
  }

  const imageUrl =
    pokemon.sprites?.official_artwork ||
    pokemon.sprites?.front_default ||
    `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png`;

  return (
    <div className="space-y-6">
      <div className="flex flex-col items-center gap-4 sm:flex-row">
        <div className="relative h-48 w-48 flex-shrink-0">
          <Image
            src={imageUrl}
            alt={pokemon.name}
            fill
            className="object-contain"
            sizes="192px"
          />
        </div>
        <div className="flex-1 space-y-2 text-center sm:text-left">
          <div className="flex flex-wrap justify-center gap-2 sm:justify-start">
            {pokemon.types.map((type) => (
              <Badge
                key={type}
                className={`${typeColors[type] || "bg-gray-500"} text-white border-0`}
              >
                {type}
              </Badge>
            ))}
          </div>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="text-muted-foreground">Height</span>
              <p className="font-medium">{(pokemon.height / 10).toFixed(1)} m</p>
            </div>
            <div>
              <span className="text-muted-foreground">Weight</span>
              <p className="font-medium">{(pokemon.weight / 10).toFixed(1)} kg</p>
            </div>
          </div>
          {pokemon.abilities && pokemon.abilities.length > 0 && (
            <div>
              <span className="text-sm text-muted-foreground">Abilities</span>
              <p className="font-medium capitalize">
                {pokemon.abilities.join(", ")}
              </p>
            </div>
          )}
        </div>
      </div>

      {pokemon.stats && pokemon.stats.length > 0 && (
        <div className="space-y-3">
          <h4 className="font-semibold">Base Stats</h4>
          <div className="space-y-2">
            {pokemon.stats.map((stat) => (
              <div key={stat.name} className="flex items-center gap-3">
                <span className="w-20 text-sm text-muted-foreground">
                  {statNames[stat.name] || stat.name}
                </span>
                <span className="w-8 text-right text-sm font-medium">
                  {stat.base_stat}
                </span>
                <div className="flex-1">
                  <Progress
                    value={(stat.base_stat / 255) * 100}
                    className={`h-2 ${getStatColor(stat.base_stat)}`}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

function PokemonDetailSkeleton() {
  return (
    <div className="space-y-6">
      <div className="flex flex-col items-center gap-4 sm:flex-row">
        <Skeleton className="h-48 w-48 rounded-lg" />
        <div className="flex-1 space-y-2">
          <div className="flex gap-2">
            <Skeleton className="h-6 w-16" />
            <Skeleton className="h-6 w-16" />
          </div>
          <div className="grid grid-cols-2 gap-4">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
          </div>
          <Skeleton className="h-8 w-3/4" />
        </div>
      </div>
      <div className="space-y-3">
        <Skeleton className="h-6 w-24" />
        {Array.from({ length: 6 }).map((_, i) => (
          <div key={i} className="flex items-center gap-3">
            <Skeleton className="h-4 w-20" />
            <Skeleton className="h-4 w-8" />
            <Skeleton className="h-2 flex-1" />
          </div>
        ))}
      </div>
    </div>
  );
}
