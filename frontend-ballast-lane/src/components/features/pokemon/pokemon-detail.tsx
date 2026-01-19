"use client";

import Image from "next/image";
import { ChevronLeft, ChevronRight, Weight as WeightIcon, Ruler, ArrowUpIcon, ArrowUp01Icon, ArrowLeftIcon } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { Skeleton } from "@/components/ui/skeleton";
import type { PokemonDetail as PokemonDetailType, PokemonBaseStats } from "@/types/pokemon";

interface PokemonDetailProps {
  pokemon: PokemonDetailType | null;
  isLoading: boolean;
  onClose?: () => void;
  onNavigate?: (name: string) => void;
}
import { typeColors, textColors } from "@/types/pokemon";
import { Icon } from "@/components/ui/icon";

const statNames: Record<keyof PokemonBaseStats, string> = {
  hp: "HP",
  attack: "ATK",
  defense: "DEF",
  special_attack: "SATK",
  special_defense: "SDEF",
  speed: "SPD",
};

export function PokemonDetailView({ pokemon, isLoading, onNavigate, onClose }: PokemonDetailProps) {
  if (isLoading) return <Skeleton />;
  if (!pokemon) return <div className="text-center text-gray-500">Pokemon not found</div>;

  const mainType = pokemon.types[0];
  const themeColor = typeColors[mainType] || "bg-gray-400";
  const textColor = textColors[mainType] || "text-gray-700";
  const imageUrl = pokemon.image || `/images/image-${pokemon.number}.png`;
  const idFormatted = `#${String(pokemon.number).padStart(3, "0")}`;

  return (
    <div className="flex flex-col h-full w-full sm:w-10/12 md:justify-around">
      <div className="flex  items-center mb-auto md:mb-0 text-grayscale-white p-5">
        <button onClick={onClose} name="back"><ArrowLeftIcon className="h-8 w-8 pr-2"  /></button>
        <h1 className="first-letter:uppercase text-xl font-bold">{pokemon.name}</h1>
        <h4 className="ml-auto text-subtitle-2 font-bold">{idFormatted}</h4>
      </div>
      <div className="mt-auto md:mt-0 flex flex-col items-start gap-4 relative self-stretch w-full">
        <div className="z-100 absolute right-3 top-[-48%]">
          <Icon size={202} name="pokeball" color="#ffffff30"></Icon>
        </div>
        
        {/* 1. Header Navigation */}
        <div className="flex items-center justify-between w-full z-20 px-5 absolute -top-10">
          <Button variant="ghost" size="icon" onClick={() => onNavigate?.(pokemon.navigation?.prev?.name ?? "")} disabled={!pokemon.navigation?.prev} className="text-white">
          { pokemon.navigation?.prev?.name && <ChevronLeft className="h-6 w-6" /> }
          </Button>
          <Button variant="ghost" size="icon" onClick={() => onNavigate?.(pokemon.navigation?.next?.name ?? "")} disabled={!pokemon.navigation?.next} className="text-white">
            <ChevronRight className="h-6 w-6" />
          </Button>
        </div>

        {/* 2. Main Details Section (The White Card) */}
        <section className="flex flex-col items-start gap-4 pt-14 px-5 pb-6 relative self-stretch w-full bg-white rounded-lg shadow-[inset_0px_1px_3px_1px_#00000040]">
          
          {/* Floating Image */}
          <div className="absolute -top-32 left-1/2 -translate-x-1/2 w-48 h-48 z-10">
            <Image src={imageUrl} alt={pokemon.name} fill className="object-contain" priority />
          </div>

          {/* Types */}
          <div className="flex justify-center gap-4 w-full mt-4">
            {pokemon.types.map((type) => (
              <Badge key={type} className={`${typeColors[type] || "bg-gray-400"} text-white border-none px-3 py-1 rounded-full capitalize`}>
                {type}
              </Badge>
            ))}
          </div>

          {/* About Heading */}
          <h2 className={`w-full text-center font-bold text-lg ${textColor}`}>About</h2>

          {/* Physical Info (Weight, Height, Moves) */}
          <div className="flex items-center self-stretch w-full py-2">
            <div className="flex flex-col items-center flex-1 border-r border-gray-200">
              <div className="flex items-center gap-2 mb-2">
                <WeightIcon className="w-4 h-4 text-gray-600" />
                <span className="text-body-3 font-medium">{(pokemon.weight / 10).toFixed(1)} kg</span>
              </div>
              <span className="text-caption text-gray-400">Weight</span>
            </div>

            <div className="flex flex-col items-center flex-1 border-r border-gray-200">
              <div className="flex items-center gap-2 mb-2">
                <Ruler className="transform rotate-45 w-4 h-4 text-gray-600" />
                <span className="text-body-3 font-medium">{(pokemon.height / 10).toFixed(1)} m</span>
              </div>
              <span className="text-caption text-gray-400">Height</span>
            </div>

            <div className="flex flex-col items-center flex-1">
              <div className="text-body-3 font-medium text-center leading-tight mb-1">
                {pokemon.moves.slice(0, 2).map(m => m.name).join("\n")}
              </div>
              <span className="text-caption text-gray-400">Moves</span>
            </div>
          </div>

          {/* Description */}
          <p className="text-body-3 text-gray-700 text-center w-full px-2 leading-relaxed">
            {pokemon.description || "No description available for this Pokémon."}
          </p>

          {/* Base Stats Heading */}
          <h2 className={`w-full text-center font-bold text-lg ${textColor}`}>Base Stats</h2>

          {/* Stats Table */}
          <div className="flex items-start gap-4 self-stretch w-full">
            <div className="flex flex-col border-r border-gray-200 pr-3">
              {(Object.keys(statNames) as Array<keyof PokemonBaseStats>).map((key) => (
                <span key={key} className={`text-body-3 font-bold text-right ${textColor}`}>
                  {statNames[key]}
                </span>
              ))}
            </div>
            
            <div className="flex flex-col pr-2">
              {(Object.entries(pokemon.base_stats) as [keyof PokemonBaseStats, number][]).map(([key, val]) => (
                <span key={key} className="text-body-3 text-gray-700 font-medium w-6 text-center">
                  {String(val).padStart(3, '0')}
                </span>
              ))}
            </div>

            <div className="flex flex-col gap-3 flex-1 pt-1.5">
              {Object.entries(pokemon.base_stats).map(([key, val]) => (
                <Progress 
                  key={key} 
                  value={(val / 255) * 100} 
                  className={`h-1 [&>div]:${themeColor}`}
                  color={themeColor}
                />
              ))}
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}
