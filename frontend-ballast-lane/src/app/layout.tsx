import type { Metadata } from "next";
import { Poppins } from "next/font/google";
import "./globals.css";
import { QueryProvider } from "@/providers/query-provider";
import { AuthProvider } from "@/providers/auth-provider";
import { Navigation } from "@/components/navigation";

const poppins = Poppins({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-poppins",
});

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
    <html lang="en">
      <body className={`${poppins.variable} ${poppins.className}`}>
        <QueryProvider>
          <AuthProvider>
            <div className="flex flex-col min-h-screen justify-center bg-primary">
              <Navigation />
              <div className="flex flex-1 bg-grayscale-background  w-full justify-center" >
                <main className="flex flex-1 lg:container  bg-primary">{children}</main>
              </div>
            </div>
          </AuthProvider>
        </QueryProvider>
      </body>
    </html>
  );
}
