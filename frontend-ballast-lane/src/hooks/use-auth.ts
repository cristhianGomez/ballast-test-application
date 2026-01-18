"use client";

import { useCallback, useEffect, useState } from "react";
import { User, AuthState } from "@/types";

const AUTH_STORAGE_KEY = "ballast_auth";

export function useAuth() {
  const [authState, setAuthState] = useState<AuthState>({
    user: null,
    token: null,
    isAuthenticated: false,
  });
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Load auth state from localStorage on mount
    const stored = localStorage.getItem(AUTH_STORAGE_KEY);
    if (stored) {
      try {
        const parsed = JSON.parse(stored);
        setAuthState({
          user: parsed.user,
          token: parsed.token,
          isAuthenticated: !!parsed.token,
        });
      } catch {
        localStorage.removeItem(AUTH_STORAGE_KEY);
      }
    }
    setIsLoading(false);
  }, []);

  const login = useCallback((user: User, token: string) => {
    const newState = {
      user,
      token,
      isAuthenticated: true,
    };
    setAuthState(newState);
    localStorage.setItem(AUTH_STORAGE_KEY, JSON.stringify({ user, token }));
  }, []);

  const logout = useCallback(() => {
    setAuthState({
      user: null,
      token: null,
      isAuthenticated: false,
    });
    localStorage.removeItem(AUTH_STORAGE_KEY);
  }, []);

  return {
    ...authState,
    isLoading,
    login,
    logout,
  };
}
