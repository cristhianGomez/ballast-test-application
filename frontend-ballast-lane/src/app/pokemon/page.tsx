import { Suspense } from "react";
import { PokemonContainer } from "@/components/features/pokemon/pokemon-container";
import { PokemonListSkeleton } from "@/components/features/pokemon/pokemon-skeleton";
import { ProtectedRoute } from "@/components/auth/protected-route";

export default function PokemonPage() {
  return (
    <ProtectedRoute>
      <div className="container mx-auto p-1 max-w-[1024px] bg-primary">
        <Suspense fallback={<PokemonListSkeleton />}>
          <PokemonContainer />
        </Suspense>
      </div>
    </ProtectedRoute>
  );
}
