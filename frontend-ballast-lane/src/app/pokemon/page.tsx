import { Suspense } from "react";
import { PokemonList } from "@/components/features/pokemon/pokemon-list";
import { PokemonListSkeleton } from "@/components/features/pokemon/pokemon-skeleton";
import { pokemonApi } from "@/lib/api";

async function PokemonData() {
  try {
    const response = await pokemonApi.list(20, 0);
    return <PokemonList pokemon={response.data} />;
  } catch {
    return (
      <div className="rounded-lg border border-destructive bg-destructive/10 p-4 text-center">
        <p className="text-destructive">Failed to load Pokemon. Please try again later.</p>
        <p className="mt-2 text-sm text-muted-foreground">
          Make sure the backend API is running at http://localhost:3000
        </p>
      </div>
    );
  }
}

export default function PokemonPage() {
  return (
    <div className="container mx-auto py-10">
      <div className="mb-8">
        <h1 className="text-3xl font-bold">Pokemon</h1>
        <p className="mt-2 text-muted-foreground">
          Browse Pokemon data from PokeAPI via our Rails backend
        </p>
      </div>

      <Suspense fallback={<PokemonListSkeleton />}>
        <PokemonData />
      </Suspense>
    </div>
  );
}
