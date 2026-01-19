import Image from "next/image";
import { Card } from "@/components/ui/card";
import type { PokemonListItem } from "@/types/pokemon";

interface PokemonCardProps {
  pokemon: PokemonListItem;
  onClick?: () => void;
}

export function PokemonCard({ pokemon, onClick }: PokemonCardProps) {
  const idFormatted = `#${String(pokemon.number).padStart(3, "0")}`;
  
  const imageUrl = pokemon.image ||
    `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.number}.png`;

  return (
    <Card
      onClick={onClick}
      className="flex flex-col w-[104px] h-[108px] items-center justify-between relative bg-white rounded-lg overflow-hidden shadow-md border-none cursor-pointer transition-transform hover:scale-105"
    >
      {/* ID Section */}
      <div className="flex items-start justify-end gap-2 pt-1 pb-0 px-2 relative self-stretch w-full">
        <span className="relative flex items-center justify-center w-fit text-caption leading-[12px] text-gray-400 text-right whitespace-nowrap">
          {idFormatted}
        </span>
      </div>

      {/* Image Container */}
      <div className="absolute top-4 z-10 w-[72px] h-[72px]">
        <Image
          src={imageUrl}
          alt={pokemon.name}
          fill
          className="object-contain"
          sizes="72px"
          priority={pokemon.number <= 20}
        />
      </div>
      {/* Name Tray (Bottom) */}
      <div className="flex items-end justify-center pb-1 px-2 relative self-stretch w-full h-[44px] bg-grayscale-background rounded-t-[7px]">
        <span className="relative flex items-center justify-center flex-1 text-body-3 text-gray-800 text-center capitalize font-medium">
          {pokemon.name}
        </span>
      </div>
    </Card>
  );
}
