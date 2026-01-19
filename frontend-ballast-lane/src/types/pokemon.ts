export interface PokemonListItem {
  number: number;
  name: string;
  image: string;
}
export interface Pokemon {
  id: number;
  name: string;
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
  abilities: string[];
  stats: PokemonStat[];
}

export interface PokemonStat {
  name: string;
  base_stat: number;
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
