// SEO Configuration and Helpers

export const siteConfig = {
  name: "Pokédex",
  description: "Explore and discover Pokemon with detailed stats, types, moves, and more. Your complete Pokemon encyclopedia.",
  url: process.env.NEXT_PUBLIC_SITE_URL || "https://pokedex.ballastlane.com",
  ogImage: "/og-image.png",
  creator: "@ballastlane",
  keywords: ["pokemon", "pokedex", "pokemon database", "pokemon stats", "pokemon types"],
};

/**
 * Generate the full URL for a given path
 */
export function getFullUrl(path: string = ""): string {
  const baseUrl = siteConfig.url.replace(/\/$/, "");
  const cleanPath = path.startsWith("/") ? path : `/${path}`;
  return `${baseUrl}${cleanPath}`;
}

/**
 * Format Pokemon name for display (capitalize first letter)
 */
export function formatPokemonName(name: string): string {
  if (!name) return "";
  return name.charAt(0).toUpperCase() + name.slice(1).toLowerCase();
}

/**
 * Generate Pokemon page title
 */
export function getPokemonTitle(name: string, number?: number): string {
  const formattedName = formatPokemonName(name);
  if (number) {
    return `${formattedName} #${number} | ${siteConfig.name}`;
  }
  return `${formattedName} | ${siteConfig.name}`;
}

/**
 * Generate Pokemon page description
 */
export function getPokemonDescription(name: string, types: string[]): string {
  const formattedName = formatPokemonName(name);
  const typeList = types.map(t => t.charAt(0).toUpperCase() + t.slice(1)).join("/");
  return `View ${formattedName}'s stats, moves, and evolution. ${formattedName} is a ${typeList} type Pokemon.`;
}
