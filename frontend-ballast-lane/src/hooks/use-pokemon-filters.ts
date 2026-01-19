"use client";

import { useSearchParams, useRouter, usePathname } from "next/navigation";
import { useCallback, useMemo } from "react";
import { PokemonListParams } from "@/lib/api";

const DEFAULT_LIMIT = 20;

export interface PokemonFilters extends PokemonListParams {
  detail?: string;
}

export function usePokemonFilters() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const pathname = usePathname();

  const filters = useMemo((): PokemonFilters => {
    const search = searchParams.get("search") || undefined;
    const sort = searchParams.get("sort") || undefined;
    const order = (searchParams.get("order") as "asc" | "desc") || undefined;
    const limit = searchParams.get("limit")
      ? parseInt(searchParams.get("limit")!, 10)
      : DEFAULT_LIMIT;
    const offset = searchParams.get("offset")
      ? parseInt(searchParams.get("offset")!, 10)
      : 0;
    const detail = searchParams.get("detail") || undefined;

    return { search, sort, order, limit, offset, detail };
  }, [searchParams]);

  const updateParams = useCallback(
    (updates: Partial<PokemonFilters>) => {
      const params = new URLSearchParams(searchParams.toString());

      Object.entries(updates).forEach(([key, value]) => {
        if (value === undefined || value === null || value === "") {
          params.delete(key);
        } else {
          params.set(key, String(value));
        }
      });

      router.push(`${pathname}?${params.toString()}`, { scroll: false });
    },
    [searchParams, router, pathname]
  );

  const setFilters = useCallback(
    (newFilters: Partial<Omit<PokemonFilters, "offset" | "detail">>) => {
      updateParams({ ...newFilters, offset: 0 });
    },
    [updateParams]
  );

  const setSelectedPokemon = useCallback(
    (name: string | null) => {
      updateParams({ detail: name ?? undefined });
    },
    [updateParams]
  );

  const currentPage = useMemo(() => {
    return Math.floor((filters.offset ?? 0) / (filters.limit ?? DEFAULT_LIMIT)) + 1;
  }, [filters.offset, filters.limit]);

  const setPage = useCallback(
    (page: number) => {
      const offset = (page - 1) * (filters.limit ?? DEFAULT_LIMIT);
      updateParams({ offset });
    },
    [filters.limit, updateParams]
  );

  const listParams = useMemo((): PokemonListParams => {
    const { detail, ...rest } = filters;
    return rest;
  }, [filters]);

  return {
    filters,
    listParams,
    setFilters,
    setSelectedPokemon,
    currentPage,
    setPage,
    selectedPokemon: filters.detail ?? null,
  };
}
