# Ballast Lane - Full Stack Application

A monorepo containing a Next.js 16 frontend and Rails 7.2 API backend, orchestrated with Docker Compose.

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Next.js 16, React 19, TypeScript 5.7, Tailwind CSS 3.4, shadcn/ui |
| **Backend** | Rails 7.2 (API mode), Ruby 3.2, PostgreSQL 15 |
| **Auth** | Devise + JWT |
| **Testing** | Jest (Frontend), RSpec 7 (Backend) |
| **Infrastructure** | Docker, Docker Compose V2 |

## Project Structure

```
Ballast-Monorepo/
├── docker compose.yml          # Development orchestration
├── docker compose.prod.yml     # Production orchestration
├── .env.example                # Environment template
├── .gitignore
├── CLAUDE.md                   # AI assistant instructions
├── README.md                   # This file
├── .claude/
│   └── rules/                  # Architecture guidelines
├── backend-ballast-lane/       # Rails 7.2 API
│   ├── Dockerfile              # Production build
│   ├── Dockerfile.dev          # Development build
│   └── README.md
└── frontend-ballast-lane/      # Next.js 16 App
    ├── Dockerfile              # Production build
    ├── Dockerfile.dev          # Development build
    └── README.md
```

## Quick Start

### 1. Clone and Setup Environment

```bash
# Copy environment file
cp .env.example .env
```

### 2. Start Development Environment

```bash
# Build and start all services
docker compose up --build

# Or run in background
docker compose up -d --build
```

### 3. Hot-Reload Development (Recommended)

```bash
# Start with file watching - auto-syncs changes without rebuilding
docker compose watch
```

This uses Docker Compose V2's `develop.watch` feature:
- **Backend**: Syncs `app/`, `config/`, `lib/` changes instantly
- **Frontend**: Syncs `src/`, `public/` changes instantly
- **Auto-rebuild**: Triggers on `Gemfile.lock` or `package-lock.json` changes

### 4. Access the Application

| Service | URL |
|---------|-----|
| Frontend | http://localhost:3001 |
| Backend API | http://localhost:3000 |
| Health Check | http://localhost:3000/health |

### 5. Seed the Database (Optional)

```bash
docker compose exec backend rails db:seed
```

This creates a test user: `test@example.com` / `password123`

## Development Commands

### Backend (Rails)

```bash
# Rails console
docker compose exec backend rails c

# Run migrations
docker compose exec backend rails db:migrate

# Run tests
docker compose exec backend bundle exec rspec

# View logs
docker compose logs -f backend
```

### Frontend (Next.js)

```bash
# Install new package
docker compose exec frontend npm install <package>

# Run tests
docker compose exec frontend npm test

# Lint
docker compose exec frontend npm run lint

# View logs
docker compose logs -f frontend
```

### Database

```bash
# PostgreSQL CLI
docker compose exec db psql -U postgres -d ballast_development

# Reset database
docker compose exec backend rails db:reset
```

## Production Deployment

### 1. Configure Production Environment

Create a `.env` file with production values:

```bash
POSTGRES_USER=ballast_user
POSTGRES_PASSWORD=<strong-password>
POSTGRES_DB=ballast_production
RAILS_ENV=production
SECRET_KEY_BASE=<generate-with-rails-secret>
DEVISE_JWT_SECRET_KEY=<secure-random-key>
RAILS_MASTER_KEY=<your-master-key>
NEXT_PUBLIC_API_URL=https://api.yourdomain.com
FRONTEND_URL=https://yourdomain.com
```

### 2. Build and Deploy

```bash
# Build production images
docker compose -f docker compose.prod.yml build

# Start production services
docker compose -f docker compose.prod.yml up -d
```

### 3. Run Migrations

```bash
docker compose -f docker compose.prod.yml exec backend rails db:migrate
```

## API Documentation

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/sign_up` | Register new user |
| POST | `/api/v1/auth/sign_in` | Login (returns JWT) |
| DELETE | `/api/v1/auth/sign_out` | Logout (revokes JWT) |

### Pokemon Endpoints (Demo)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/pokemon` | List Pokemon |
| GET | `/api/v1/pokemon/:id` | Get Pokemon details |

### Health Check

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Service status |

## Environment Variables

| Variable | Service | Description |
|----------|---------|-------------|
| `POSTGRES_USER` | db | Database username |
| `POSTGRES_PASSWORD` | db | Database password |
| `POSTGRES_DB` | db | Database name |
| `DATABASE_URL` | backend | PostgreSQL connection string |
| `RAILS_ENV` | backend | Rails environment |
| `DEVISE_JWT_SECRET_KEY` | backend | JWT signing key |
| `FRONTEND_URL` | backend | CORS allowed origin |
| `SECRET_KEY_BASE` | backend | Rails secret (production) |
| `NEXT_PUBLIC_API_URL` | frontend | Backend API URL |

## Troubleshooting

### Database Connection Issues

```bash
# Check if database is running
docker compose ps

# Restart database
docker compose restart db

# Check database logs
docker compose logs db
```

### Frontend Build Issues

```bash
# Clear node_modules volume
docker compose down -v
docker compose up --build
```

### Backend Issues

```bash
# Check Rails logs
docker compose logs backend

# Recreate database
docker compose exec backend rails db:drop db:create db:migrate
```

## Architecture

See individual README files for detailed architecture:
- [Backend Architecture](./backend-ballast-lane/README.md)
- [Frontend Architecture](./frontend-ballast-lane/README.md)

## License

Private - All rights reserved.
