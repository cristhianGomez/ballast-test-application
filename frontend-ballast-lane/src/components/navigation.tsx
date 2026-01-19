"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useAuth } from "@/providers/auth-provider";
import { Button } from "@/components/ui/button";
import { authApi } from "@/lib/api";

export function Navigation() {
  const { user, isAuthenticated, isLoading, logout, getToken } = useAuth();
  const router = useRouter();

  const handleLogout = async () => {
    const token = getToken();
    if (token) {
      try {
        await authApi.signOut(token);
      } catch {
        // Ignore errors, still logout locally
      }
    }
    logout();
    router.push("/login");
  };

  return (
    <nav className="border-b">
      <div className="container mx-auto flex h-16 items-center justify-between px-4">
        <Link href="/" className="text-xl font-bold">
          Ballast Lane
        </Link>
        <div className="flex items-center gap-4">
          <Link href="/pokemon" className="text-sm hover:underline">
            Pokemon
          </Link>
          {isLoading ? (
            <div className="h-9 w-20 animate-pulse rounded bg-muted" />
          ) : isAuthenticated ? (
            <>
              <span className="text-sm text-muted-foreground">{user?.email}</span>
              <Button variant="outline" size="sm" onClick={handleLogout}>
                Logout
              </Button>
            </>
          ) : (
            <>
              <Link href="/login" className="text-sm hover:underline">
                Login
              </Link>
              <Link href="/register" className="text-sm hover:underline">
                Register
              </Link>
            </>
          )}
        </div>
      </div>
    </nav>
  );
}
