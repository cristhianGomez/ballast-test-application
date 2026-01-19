"use client";

import { useQuery, keepPreviousData } from "@tanstack/react-query";
import { pokemonApi, PokemonListParams } from "@/lib/api";

export const pokemonKeys = {
  all: ["pokemon"] as const,
  lists: () => [...pokemonKeys.all, "list"] as const,
  list: (params: PokemonListParams) => [...pokemonKeys.lists(), params] as const,
  details: () => [...pokemonKeys.all, "detail"] as const,
  detail: (nameOrId: string | number) => [...pokemonKeys.details(), nameOrId] as const,
};

export function usePokemonList(params: PokemonListParams = {}) {
  return useQuery({
    queryKey: pokemonKeys.list(params),
    queryFn: () => pokemonApi.list(params),
    placeholderData: keepPreviousData,
  });
}

export function usePokemonDetail(nameOrId: string | number | null) {
  return useQuery({
    queryKey: pokemonKeys.detail(nameOrId ?? ""),
    queryFn: () => pokemonApi.get(nameOrId!),
    enabled: !!nameOrId,
  });
}
