import { Suspense } from "react";
import { PokemonContainer } from "@/components/features/pokemon/pokemon-container";
import { PokemonListSkeleton } from "@/components/features/pokemon/pokemon-skeleton";
import { ProtectedRoute } from "@/components/auth/protected-route";
import { Icon } from "@/components/ui/icon";

export default function PokemonPage() {
  return (
    <ProtectedRoute>
      <div className="container mx-auto p-1 max-w-[1024px] bg-primary">
        <div className="m-3 mt-4 flex items-center gap-4">
          <Icon name="pokeball" size={24} color="white" />
          <h1 className="text-headline font-bold text-grayscale-white">Pokedex</h1>
        </div>

        <Suspense fallback={<PokemonListSkeleton />}>
          <PokemonContainer />
        </Suspense>
      </div>
    </ProtectedRoute>
  );
}
