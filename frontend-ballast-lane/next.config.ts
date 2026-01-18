import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Keeps the Docker image size small for production
  output: "standalone",

  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "raw.githubusercontent.com",
        pathname: "/PokeAPI/sprites/**",
      },
    ],
  },

  async rewrites() {
    return [
      {
        // Proxies requests from frontend:3001/api to backend:3000/api
        source: "/api/:path*",
        destination: `${process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000"}/api/:path*`,
      },
    ];
  },
};

export default nextConfig;
