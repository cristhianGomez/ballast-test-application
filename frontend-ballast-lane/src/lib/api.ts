import { getStoredToken, clearStoredAuth } from "@/providers/auth-provider";

const API_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000";

type RequestOptions = {
  method?: "GET" | "POST" | "PUT" | "PATCH" | "DELETE";
  body?: unknown;
  headers?: Record<string, string>;
  token?: string;
  skipAuth?: boolean;
};

export class ApiError extends Error {
  constructor(
    message: string,
    public status: number,
    public data?: unknown
  ) {
    super(message);
    this.name = "ApiError";
  }
}

export async function api<T>(endpoint: string, options: RequestOptions = {}): Promise<T> {
  const { method = "GET", body, headers = {}, token, skipAuth = false } = options;

  const requestHeaders: Record<string, string> = {
    "Content-Type": "application/json",
    Accept: "application/json",
    ...headers,
  };

  const authToken = token || (!skipAuth ? getStoredToken() : null);
  if (authToken) {
    requestHeaders["Authorization"] = `Bearer ${authToken}`;
  }

  const response = await fetch(`${API_URL}${endpoint}`, {
    method,
    headers: requestHeaders,
    body: body ? JSON.stringify(body) : undefined,
    credentials: "include",
  });

  // Handle 401 globally
  if (response.status === 401 && !skipAuth) {
    clearStoredAuth();
    if (typeof window !== "undefined") {
      window.location.href = "/login";
    }
    throw new ApiError("Unauthorized", 401);
  }

  const data = await response.json();

  if (!response.ok) {
    throw new ApiError(data.message || "An error occurred", response.status, data);
  }

  return data;
}

export async function apiLogin(
  email: string,
  password: string
): Promise<{ data: AuthResponse["data"]; token: string }> {
  const response = await fetch(`${API_URL}/api/v1/auth/sign_in`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify({ user: { email, password } }),
    credentials: "include",
  });

  const data = await response.json();

  if (!response.ok) {
    throw new ApiError(data.message || "Login failed", response.status, data);
  }

  const authHeader = response.headers.get("Authorization");
  const token = authHeader?.replace("Bearer ", "") || "";

  return { data: data.data, token };
}

export async function apiSignUp(
  email: string,
  password: string,
  passwordConfirmation: string
): Promise<{ data: AuthResponse["data"]; token: string }> {
  const response = await fetch(`${API_URL}/api/v1/auth/sign_up`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify({
      user: { email, password, password_confirmation: passwordConfirmation },
    }),
    credentials: "include",
  });

  const data = await response.json();

  if (!response.ok) {
    throw new ApiError(data.message || "Registration failed", response.status, data);
  }

  const authHeader = response.headers.get("Authorization");
  const token = authHeader?.replace("Bearer ", "") || "";

  return { data: data.data, token };
}

// Auth API
export const authApi = {
  signUp: (email: string, password: string, passwordConfirmation: string) =>
    api<AuthResponse>("/api/v1/auth/sign_up", {
      method: "POST",
      body: { user: { email, password, password_confirmation: passwordConfirmation } },
    }),

  signIn: (email: string, password: string) =>
    api<AuthResponse>("/api/v1/auth/sign_in", {
      method: "POST",
      body: { user: { email, password } },
    }),

  signOut: (token: string) =>
    api("/api/v1/auth/sign_out", {
      method: "DELETE",
      token,
    }),
};

// Pokemon API
export interface PokemonListParams {
  search?: string;
  sort?: string;
  order?: "asc" | "desc";
  limit?: number;
  offset?: number;
}

export const pokemonApi = {
  list: (params: PokemonListParams = {}) => {
    const { search, sort, order, limit = 20, offset = 0 } = params;
    const queryParams = new URLSearchParams();
    queryParams.set("limit", String(limit));
    queryParams.set("offset", String(offset));
    if (search) queryParams.set("search", search);
    if (sort) queryParams.set("sort", sort);
    if (order) queryParams.set("order", order);
    return api<PokemonListResponse>(`/api/v1/pokemon?${queryParams.toString()}`);
  },

  get: (nameOrId: string | number) => api<PokemonDetailResponse>(`/api/v1/pokemon/${nameOrId}`),
};

// Types
export interface AuthResponse {
  success: boolean;
  message: string;
  data: {
    id: number;
    email: string;
    created_at: string;
  };
}

export interface PokemonListItem {
  number: number;
  name: string;
  image: string;
}

export interface PokemonListResponse {
  success: boolean;
  data: PokemonListItem[];
  meta: {
    count: number;
    limit: number;
    offset: number;
  };
}

export interface PokemonDetailResponse {
  success: boolean;
  data: PokemonDetail;
}

export interface Pokemon {
  id: number;
  name: string;
  sprites?: {
    front_default?: string;
    official_artwork?: string;
  };
  types: string[];
}

export interface PokemonDetail extends Pokemon {
  height: number;
  weight: number;
  abilities: string[];
  stats: {
    name: string;
    base_stat: number;
  }[];
}
