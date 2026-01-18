import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Ballast Lane",
  description: "Full-stack application with Next.js and Rails",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" >
      <body className={inter.className}>
        <div className="min-h-screen bg-background">
          <nav className="border-b">
            <div className="container mx-auto flex h-16 items-center justify-between px-4">
              <a href="/" className="text-xl font-bold">
                Ballast Lane
              </a>
              <div className="flex items-center gap-4">
                <a href="/pokemon" className="text-sm hover:underline">
                  Pokemon
                </a>
                <a href="/login" className="text-sm hover:underline">
                  Login
                </a>
                <a href="/register" className="text-sm hover:underline">
                  Register
                </a>
              </div>
            </div>
          </nav>
          <main>{children}</main>
        </div>
      </body>
    </html>
  );
}
