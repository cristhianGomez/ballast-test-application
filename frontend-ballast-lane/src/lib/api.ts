const API_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000";

type RequestOptions = {
  method?: "GET" | "POST" | "PUT" | "PATCH" | "DELETE";
  body?: unknown;
  headers?: Record<string, string>;
  token?: string;
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
  const { method = "GET", body, headers = {}, token } = options;

  const requestHeaders: Record<string, string> = {
    "Content-Type": "application/json",
    Accept: "application/json",
    ...headers,
  };

  if (token) {
    requestHeaders["Authorization"] = `Bearer ${token}`;
  }

  const response = await fetch(`${API_URL}${endpoint}`, {
    method,
    headers: requestHeaders,
    body: body ? JSON.stringify(body) : undefined,
    credentials: "include",
  });

  const data = await response.json();

  if (!response.ok) {
    throw new ApiError(data.message || "An error occurred", response.status, data);
  }

  return data;
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
export const pokemonApi = {
  list: (limit = 20, offset = 0) =>
    api<PokemonListResponse>(`/api/v1/pokemon?limit=${limit}&offset=${offset}`),

  get: (id: string | number) => api<PokemonDetailResponse>(`/api/v1/pokemon/${id}`),
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

export interface PokemonListResponse {
  success: boolean;
  data: Pokemon[];
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
