import Image from "next/image";
import { notFound } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { pokemonApi } from "@/lib/api";

const typeColors: Record<string, string> = {
  normal: "bg-gray-400",
  fire: "bg-orange-500",
  water: "bg-blue-500",
  electric: "bg-yellow-400",
  grass: "bg-green-500",
  ice: "bg-cyan-400",
  fighting: "bg-red-600",
  poison: "bg-purple-500",
  ground: "bg-amber-600",
  flying: "bg-indigo-400",
  psychic: "bg-pink-500",
  bug: "bg-lime-500",
  rock: "bg-stone-500",
  ghost: "bg-violet-600",
  dragon: "bg-indigo-600",
  dark: "bg-gray-700",
  steel: "bg-slate-400",
  fairy: "bg-pink-400",
};

interface PokemonDetailPageProps {
  params: Promise<{ id: string }>;
}

export default async function PokemonDetailPage({ params }: PokemonDetailPageProps) {
  const { id } = await params;

  try {
    const response = await pokemonApi.get(id);
    const pokemon = response.data;

    const imageUrl =
      pokemon.image ||
      pokemon.sprites?.official_artwork ||
      pokemon.sprites?.front_default ||
      `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.number}.png`;

    return (
      <div className="container mx-auto py-10">
        <div className="mb-6">
          <Button variant="outline" asChild>
            <a href="/pokemon">Back to List</a>
          </Button>
        </div>

        <div className="grid gap-8 md:grid-cols-2">
          <Card>
            <CardContent className="p-6">
              <div className="relative aspect-square w-full">
                <Image
                  src={imageUrl}
                  alt={pokemon.name}
                  fill
                  className="object-contain"
                  sizes="(max-width: 768px) 100vw, 50vw"
                  priority
                />
              </div>
            </CardContent>
          </Card>

          <div className="space-y-6">
            <Card>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle className="text-3xl capitalize">{pokemon.name}</CardTitle>
                  <span className="text-xl text-muted-foreground">#{pokemon.number}</span>
                </div>
              </CardHeader>
              <CardContent>
                <div className="flex flex-wrap gap-2">
                  {pokemon.types.map((type) => (
                    <span
                      key={type}
                      className={`rounded-full px-4 py-2 text-sm font-medium text-white ${
                        typeColors[type] || "bg-gray-500"
                      }`}
                    >
                      {type}
                    </span>
                  ))}
                </div>

                <div className="mt-6 grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm text-muted-foreground">Height</p>
                    <p className="text-lg font-medium">{(pokemon.height / 10).toFixed(1)} m</p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Weight</p>
                    <p className="text-lg font-medium">{(pokemon.weight / 10).toFixed(1)} kg</p>
                  </div>
                </div>

                <div className="mt-6">
                  <p className="text-sm font-medium text-muted-foreground">Moves</p>
                  <div className="mt-2 flex flex-wrap gap-2">
                    {pokemon.moves.slice(0, 6).map((move) => (
                      <span
                        key={move.name}
                        className="rounded-md bg-muted px-3 py-1 text-sm capitalize"
                      >
                        {move.name.replace("-", " ")}
                      </span>
                    ))}
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Base Stats</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {Object.entries(pokemon.base_stats).map(([statName, value]) => (
                    <div key={statName}>
                      <div className="flex justify-between text-sm">
                        <span className="capitalize">{statName.replace("_", " ")}</span>
                        <span className="font-medium">{value}</span>
                      </div>
                      <div className="mt-1 h-2 w-full overflow-hidden rounded-full bg-muted">
                        <div
                          className="h-full rounded-full bg-primary transition-all"
                          style={{ width: `${Math.min(100, (value / 255) * 100)}%` }}
                        />
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    );
  } catch {
    notFound();
  }
}
