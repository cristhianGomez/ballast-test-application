"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useAuth } from "@/providers/auth-provider";
import { authApi } from "@/lib/api";
import { Icon } from "./ui/icon";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";

export function Navigation() {
  const { user, isAuthenticated, isLoading, logout, getToken } = useAuth();
  const router = useRouter();
  const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);

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
    setIsUserMenuOpen(false);
    router.push("/login");
  };

  return (
    <nav className="">
      <div className="container bg-primary mx-auto flex h-16 items-center justify-between px-4">
        <div className="m-3 mt-4 flex items-center gap-4">
          <Icon name="pokeball" size={24} color="white" />
          <h1 className="text-headline font-bold text-grayscale-white">Pokédex</h1>
        </div>
        <div className="flex items-center gap-4">
          {isLoading ? (
            <div className="h-9 w-9 animate-pulse rounded-full bg-white/20" />
          ) : isAuthenticated ? (
            <Popover open={isUserMenuOpen} onOpenChange={setIsUserMenuOpen}>
              <PopoverTrigger asChild>
                <button
                  className="flex items-center justify-center w-8 h-8 bg-white rounded-full shadow-inner-2 hover:bg-gray-50 transition-colors"
                  aria-label="User menu"
                >
                  <Icon name="user" size={16} className="w-3" color="#DC0A2D" />
                </button>
              </PopoverTrigger>
              <PopoverContent
                className="w-[160px] p-1 shadow-drop-2 rounded-xl border-0"
                align="end"
                sideOffset={8}
              >
                <div className="space-y-1">
                  {/* Email */}
                  <div className="px-3 py-2 border-b border-grayscale-light">
                    <p className="text-caption text-grayscale-medium">Signed in as</p>
                    <p className="text-body-3 text-grayscale-dark truncate">{user?.email}</p>
                  </div>

                  {/* Logout Button */}
                  <button
                    onClick={handleLogout}
                    className="flex items-center gap-2 w-full px-3 py-2 hover:bg-gray-50 rounded-lg transition-colors text-primary"
                  >
                    <Icon name="close" size={16} color="#DC0A2D" />
                    <span className="text-body-3">Logout</span>
                  </button>
                </div>
              </PopoverContent>
            </Popover>
          ) : (
            <>
              <Link href="/login" className="text-sm text-white hover:underline">
                Login
              </Link>
              <Link href="/register" className="text-sm text-white hover:underline">
                Register
              </Link>
            </>
          )}
        </div>
      </div>
    </nav>
  );
}
