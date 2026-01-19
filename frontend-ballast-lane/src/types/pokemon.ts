export interface PokemonListItem {
  number: number;
  name: string;
  image: string;
}
export interface Pokemon {
  name: string;
  image: string;
  description?: string
  number: number;
  sprites?: PokemonSprites;
  types: string[];
}

export interface PokemonSprites {
  front_default?: string;
  back_default?: string;
  front_shiny?: string;
  official_artwork?: string;
}

export interface PokemonDetail extends Pokemon {
  height: number;
  weight: number;
  base_stats: PokemonBaseStats;
  moves: PokemonMove[];
  navigation: PokemonNavigation;
}

export interface PokemonBaseStats {
  hp: number;
  attack: number;
  defense: number;
  special_attack: number;
  special_defense: number;
  speed: number;
}

export interface PokemonMove {
  name: string;
  learn_method: string;
  level_learned_at: number;
}

export interface PokemonNavigation {
  prev: PokemonNavItem | null;
  next: PokemonNavItem | null;
}

export interface PokemonNavItem {
  number: number;
  name: string;
}

export interface PokemonListResponse {
  success: boolean;
  data: PokemonListItem[];
  meta: {
    count: number;
    limit: number;
    offset: number;
  };
}

export interface PokemonDetailResponse {
  success: boolean;
  data: PokemonDetail;
}

export const typeColors: Record<string, string> = {
  dragon: "bg-pokemon-dragron",
  electric: "bg-pokemon-electric",
  fairy: "bg-pokemon-fairy",
  fighting: "bg-pokemon-fighting",
  fire: "bg-pokemon-fire",
  flying: "bg-pokemon-flying",
  ghost: "bg-pokemon-ghost",
  normal: "bg-pokemon-normal",
  grass: "bg-pokemon-grass",
  ground: "bg-pokemon-ground",
  ice: "bg-pokemon-ice",
  poison: "bg-pokemon-poison",
  psychic: "bg-pokemon-psychic",
  rock: "bg-pokemon-rock",
  steel: "bg-pokemon-steel",
  water: "bg-pokemon-water",
};
export const textColors: Record<string, string> = {
  dragon: "text-pokemon-dragon",
  electric: "text-pokemon-electric",
  fairy: "text-pokemon-fairy",
  fighting: "text-pokemon-fighting",
  fire: "text-pokemon-fire",
  flying: "text-pokemon-flying",
  ghost: "text-pokemon-ghost",
  normal: "text-pokemon-normal",
  grass: "text-pokemon-grass",
  ground: "text-pokemon-ground",
  ice: "text-pokemon-ice",
  poison: "text-pokemon-poison",
  psychic: "text-pokemon-psychic",
  rock: "text-pokemon-rock",
  steel: "text-pokemon-steel",
  water: "text-pokemon-water",
};
