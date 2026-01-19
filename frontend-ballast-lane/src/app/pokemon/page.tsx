import type { Metadata } from "next";
import { Suspense } from "react";
import { PokemonContainer } from "@/components/features/pokemon/pokemon-container";
import { PokemonListSkeleton } from "@/components/features/pokemon/pokemon-skeleton";
import { ProtectedRoute } from "@/components/auth/protected-route";

export const metadata: Metadata = {
  title: "Pokemon List",
  description: "Browse and search through all Pokemon. View stats, types, and detailed information for each Pokemon in the Pokedex.",
  openGraph: {
    title: "Pokemon List | Pokedex",
    description: "Browse and search through all Pokemon. View stats, types, and detailed information for each Pokemon in the Pokedex.",
  },
};

export default function PokemonPage() {
  return (
    <ProtectedRoute>
      <div className="container  mx-auto p-1 max-w-[1024px] bg-primary">
        <Suspense fallback={<PokemonListSkeleton />}>
          <PokemonContainer />
        </Suspense>
      </div>
    </ProtectedRoute>
  );
}
