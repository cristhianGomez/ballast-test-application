"use client";

import { usePokemonList, usePokemonDetail } from "@/hooks/use-pokemon";
import { usePokemonFilters } from "@/hooks/use-pokemon-filters";
import { PokemonFilters } from "./pokemon-filters";
import { PokemonPagination } from "./pokemon-pagination";
import { PokemonCard } from "./pokemon-card";
import { PokemonDetailView } from "./pokemon-detail";
import { PokemonListSkeleton } from "./pokemon-skeleton";
import { ResponsiveDetail } from "@/components/ui/responsive-detail";

export function PokemonContainer() {
  const {
    listParams,
    filters,
    setFilters,
    setSelectedPokemon,
    selectedPokemon,
    currentPage,
    setPage,
  } = usePokemonFilters();

  const { data, isLoading, isError } = usePokemonList(listParams);
  const { data: detailData, isLoading: isDetailLoading } = usePokemonDetail(selectedPokemon);

  const handleCardClick = (name: string) => {
    setSelectedPokemon(name);
  };

  const handleDetailClose = (open: boolean) => {
    if (!open) {
      setSelectedPokemon(null);
    }
  };

  const handleNavigate = (name: string) => {
    setSelectedPokemon(name);
  };

  if (isError) {
    return (
      <div className="rounded-lg border border-destructive bg-destructive/10 p-4 text-center">
        <p className="text-destructive">Failed to load Pokemon. Please try again later.</p>
        <p className="mt-2 text-sm text-muted-foreground">
          Make sure the backend API is running at http://localhost:3000
        </p>
      </div>
    );
  }

  return (
    <div className="flex flex-col h-full space-y-6">
      <PokemonFilters
        search={filters.search}
        sort={filters.sort}
        order={filters.order}
        onFiltersChange={setFilters}
      />

      {isLoading ? (
        <PokemonListSkeleton />
      ) : data?.data && data.data.length > 0 ? (
        <>
          <div className="flex-1 bg-white rounded-md sm:px-3 sm:py-6 grid grid-cols-[repeat(auto-fill,minmax(104px,max-content))] sm:grid-cols-[repeat(auto-fill,minmax(148px,max-content))] gap-2 justify-center">
            {data.data.map((pokemon) => (
              <PokemonCard
                key={pokemon.number}
                pokemon={pokemon}
                onClick={() => handleCardClick(pokemon.name)}
              />
            ))}
          </div>

          {data.meta && (
            <PokemonPagination
              currentPage={currentPage}
              totalCount={data.meta.count}
              limit={filters.limit ?? 20}
              onPageChange={setPage}
            />
          )}
        </>
      ) : (
        <div className="text-center text-gray-200 py-8">
          {filters.search ? (
            <p>No Pokemon found matching &quot;{filters.search}&quot;</p>
          ) : (
            <p>No Pokemon available</p>
          )}
        </div>
      )}

      <ResponsiveDetail
        open={!!selectedPokemon}
        onOpenChange={handleDetailClose}
        title={selectedPokemon ? `${selectedPokemon}` : "Pokemon Detail"}
        description="Pokemon details and stats"
        color={detailData?.data.types.find(type => type) || "water"}
      >
        <PokemonDetailView
          onClose={() => setSelectedPokemon(null)}
          pokemon={detailData?.data ?? null}
          isLoading={isDetailLoading}
          onNavigate={handleNavigate}
        />
      </ResponsiveDetail>
    </div>
  );
}
