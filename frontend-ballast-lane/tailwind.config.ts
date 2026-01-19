import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
    
    "./src/**/*.{js,ts,jsx,tsx}",
    "./src/types/**/*.{ts,js}",
  ],
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      fontFamily: {
        sans: ["var(--font-poppins)", "system-ui", "sans-serif"],
        poppins: ["var(--font-poppins)", "system-ui", "sans-serif"],
      },
      fontSize: {
        // Headers - Bold
        "headline": ["24px", { lineHeight: "32px", fontWeight: "700" }],
        "subtitle-1": ["14px", { lineHeight: "16px", fontWeight: "700" }],
        "subtitle-2": ["12px", { lineHeight: "16px", fontWeight: "700" }],
        "subtitle-3": ["10px", { lineHeight: "16px", fontWeight: "700" }],
        // Body - Regular
        "body-1": ["14px", { lineHeight: "16px", fontWeight: "400" }],
        "body-2": ["12px", { lineHeight: "16px", fontWeight: "400" }],
        "body-3": ["10px", { lineHeight: "16px", fontWeight: "400" }],
        "caption": ["8px", { lineHeight: "12px", fontWeight: "400" }],
      },
      boxShadow: {
        // Drop shadows
        "drop-2": "0px 1px 3px 1px rgba(0, 0, 0, 0.2), 0px 1px 2px 0px rgba(0, 0, 0, 0.2)",
        "drop-6": "0px 2px 6px 2px rgba(0, 0, 0, 0.2), 0px 1px 2px 0px rgba(0, 0, 0, 0.3)",
        // Inner shadows
        "inner-2": "inset 0px 1px 3px 1px rgba(0, 0, 0, 0.2)",
      },
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "#DC0A2D",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
        // Pokemon type colors
        pokemon: {
          bug: "#A7B723",
          dark: "#75574C",
          dragon: "#7037FF",
          electric: "#F9CF30",
          fairy: "#E69EAC",
          fighting: "#C12239",
          fire: "#F57D31",
          flying: "#A891EC",
          ghost: "#70559B",
          normal: "#AAA67F",
          grass: "#74CB48",
          ground: "#DEC16B",
          ice: "#9AD6DF",
          poison: "#A43E9E",
          psychic: "#FB5584",
          rock: "#B69E31",
          steel: "#B7B9D0",
          water: "#6493EB",
        },
        // Grayscale palette
        grayscale: {
          dark: "#212121",
          medium: "#666666",
          light: "#E0E0E0",
          background: "#EFEFEF",
          white: "#FFFFFF",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: "0" },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: "0" },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
};

export default config;
