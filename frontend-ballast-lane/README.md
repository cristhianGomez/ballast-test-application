# Frontend - Ballast Lane

Next.js 16 frontend with React 19, TypeScript, Tailwind CSS, and shadcn/ui components.

## Tech Stack

- **Next.js** 16 (App Router + Turbopack)
- **React** 19
- **TypeScript** 5.7
- **Tailwind CSS** 3.4
- **shadcn/ui** (New York style, Zinc palette)
- **React Hook Form** + **Zod** for validation
- **Jest** + **React Testing Library** for testing

## Getting Started

### With Docker (Recommended)

From the project root directory:

```bash
# Build and start all services
docker compose up --build

# Run in background
docker compose up -d
```

The app will be available at `http://localhost:3001`

### Without Docker

```bash
# Install dependencies
npm install

# Start development server
npm run dev
```

## Available Scripts

```bash
npm run dev      # Start development server
npm run build    # Build for production
npm run start    # Start production server
npm run lint     # Run ESLint
npm test         # Run tests
npm run test:watch  # Run tests in watch mode
```

## Project Structure

```
frontend-ballast-lane/
├── src/
│   ├── app/                      # Next.js App Router
│   │   ├── layout.tsx            # Root layout
│   │   ├── page.tsx              # Home page
│   │   ├── globals.css           # Global styles
│   │   ├── (auth)/               # Auth route group
│   │   │   ├── login/page.tsx
│   │   │   └── register/page.tsx
│   │   ├── (dashboard)/          # Protected route group
│   │   │   └── dashboard/page.tsx
│   │   └── pokemon/              # Pokemon feature
│   │       ├── page.tsx          # List page
│   │       └── [id]/page.tsx     # Detail page
│   ├── components/
│   │   ├── ui/                   # shadcn/ui components
│   │   │   ├── button.tsx
│   │   │   ├── card.tsx
│   │   │   ├── form.tsx
│   │   │   ├── input.tsx
│   │   │   ├── label.tsx
│   │   │   ├── skeleton.tsx
│   │   │   └── toast.tsx
│   │   ├── features/             # Feature components
│   │   │   └── pokemon/
│   │   │       ├── pokemon-card.tsx
│   │   │       ├── pokemon-list.tsx
│   │   │       └── pokemon-skeleton.tsx
│   │   └── auth/                 # Auth components
│   │       ├── login-form.tsx
│   │       └── register-form.tsx
│   ├── lib/
│   │   ├── api.ts                # API client
│   │   ├── utils.ts              # Utilities (cn helper)
│   │   └── validations/
│   │       └── auth.ts           # Zod schemas
│   ├── hooks/
│   │   └── use-auth.ts           # Auth hook
│   ├── types/
│   │   ├── index.ts              # Common types
│   │   └── pokemon.ts            # Pokemon types
│   └── middleware.ts             # Next.js middleware
├── public/
├── components.json               # shadcn/ui config
├── tailwind.config.ts
├── next.config.ts
└── tsconfig.json
```

## Pages

| Route | Description | Auth Required |
|-------|-------------|---------------|
| `/` | Home page with navigation | No |
| `/pokemon` | Pokemon list (Server Component) | No |
| `/pokemon/:id` | Pokemon detail page | No |
| `/login` | Login form | No |
| `/register` | Registration form | No |
| `/dashboard` | User dashboard | Yes |

## API Integration

The `lib/api.ts` module provides typed API calls:

```typescript
import { pokemonApi, authApi } from "@/lib/api";

// Pokemon
const list = await pokemonApi.list(20, 0);
const detail = await pokemonApi.get(1);

// Auth
const user = await authApi.signIn(email, password);
await authApi.signOut(token);
```

## Authentication

- JWT tokens stored in localStorage (via `useAuth` hook)
- Protected routes redirect to `/login` if not authenticated
- Login/Register forms with Zod validation

## Adding shadcn/ui Components

```bash
npx shadcn@latest add [component-name]

# Examples:
npx shadcn@latest add dialog
npx shadcn@latest add dropdown-menu
npx shadcn@latest add table
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NEXT_PUBLIC_API_URL` | Backend API URL | http://localhost:3000 |

Create a `.env.local` file:

```bash
NEXT_PUBLIC_API_URL=http://localhost:3000
```

## Architecture Patterns

1. **Server Components First**: Default to RSC, use `"use client"` only when needed
2. **Colocation**: Related files kept together
3. **Mobile First**: Base styles for mobile, then `md:`, `lg:` breakpoints
4. **Zod Validation**: No `any` types, validate all inputs
5. **ActionResult Pattern**: Consistent server response format

## Development Tips

### TypeScript Strict Mode
The project uses strict TypeScript. Avoid `any` types.

### Styling
Use the `cn()` utility for conditional classes:

```tsx
import { cn } from "@/lib/utils";

<div className={cn("base-class", isActive && "active-class")} />
```

### Form Handling
Use React Hook Form with Zod:

```tsx
const form = useForm<FormData>({
  resolver: zodResolver(schema),
  defaultValues: { ... }
});
```
