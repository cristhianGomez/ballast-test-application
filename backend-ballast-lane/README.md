# Backend - Ballast Lane API

Rails 7.2 API backend with PostgreSQL, Devise + JWT authentication, and PokeAPI integration.

## Tech Stack

- **Ruby** 3.2+
- **Rails** 7.2 (API Mode)
- **PostgreSQL** 15
- **Authentication**: Devise + devise-jwt 0.12
- **Testing**: RSpec 7, FactoryBot, Shoulda Matchers
- **Linting**: RuboCop

## Getting Started

### With Docker (Recommended)

From the project root directory:

```bash
# Build and start all services
docker compose up --build

# Run in background
docker compose up -d
```

The API will be available at `http://localhost:3000`

### Without Docker

```bash
# Install dependencies
bundle install

# Setup database
rails db:create db:migrate db:seed

# Start server
rails s
```

## API Endpoints

### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/auth/sign_up` | Register new user | No |
| POST | `/api/v1/auth/sign_in` | Login, returns JWT | No |
| DELETE | `/api/v1/auth/sign_out` | Logout, revokes JWT | Yes |

**Request body for sign_up/sign_in:**
```json
{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "password_confirmation": "password123"  // only for sign_up
  }
}
```

**Response:**
```json
{
  "success": true,
  "message": "Logged in successfully.",
  "data": {
    "id": 1,
    "email": "user@example.com",
    "created_at": "2024-01-01T00:00:00.000Z"
  }
}
```

JWT token is returned in the `Authorization` header.

### Pokemon

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/pokemon` | List Pokemon (paginated) | No |
| GET | `/api/v1/pokemon/:id` | Get Pokemon details | No |

**Query Parameters for list:**
- `limit` (default: 20)
- `offset` (default: 0)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "bulbasaur",
      "sprites": { "front_default": "...", "official_artwork": "..." },
      "types": ["grass", "poison"]
    }
  ],
  "meta": {
    "count": 1000,
    "limit": 20,
    "offset": 0
  }
}
```

### Health Check

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Service health status |

## Project Structure

```
backend-ballast-lane/
├── app/
│   ├── controllers/
│   │   ├── api/v1/           # Versioned API controllers
│   │   │   ├── base_controller.rb
│   │   │   ├── pokemon_controller.rb
│   │   │   ├── sessions_controller.rb
│   │   │   └── registrations_controller.rb
│   │   ├── application_controller.rb
│   │   └── health_controller.rb
│   ├── models/
│   │   ├── user.rb           # Devise user model
│   │   └── jwt_denylist.rb   # JWT revocation
│   ├── jobs/
│   │   └── pokemon_sync_job.rb # Pokemon data sync from PokeAPI
│   ├── services/
│   │   ├── pokemon_service.rb      # Pokemon listing service
│   │   ├── pokemon_detail_service.rb # Pokemon detail service
│   │   └── pokemon_sync_service.rb # PokeAPI sync service
│   └── serializers/
│       ├── user_serializer.rb
│       └── pokemon_serializer.rb
├── config/
│   ├── database.yml
│   ├── routes.rb
│   └── initializers/
│       ├── 0_devise_setup.rb # Early Devise ORM loading (fixes devise-jwt issue)
│       ├── cors.rb           # CORS configuration
│       ├── devise.rb         # Devise + JWT config
│       ├── good_job.rb       # Background job configuration
│       └── rack_attack.rb    # Rate limiting configuration
├── db/
│   └── migrate/
└── spec/                     # RSpec tests
```

## Development

### Running Tests

```bash
# With Docker
docker compose exec backend bundle exec rspec

# Without Docker
bundle exec rspec
```

### Linting

```bash
bundle exec rubocop
```

### Rails Console

```bash
# With Docker
docker compose exec backend rails c

# Without Docker
rails c
```

### Database Commands

```bash
# With Docker
docker compose exec backend rails db:migrate
docker compose exec backend rails db:seed
docker compose exec backend rails db:reset

# Without Docker
rails db:migrate
rails db:seed
```

### Background Jobs (GoodJob)

The application uses [GoodJob](https://github.com/bensheldon/good_job) for background job processing with PostgreSQL (no Redis required).

**Pokemon Sync Job** - Syncs Pokemon data from PokeAPI to the local database.

```bash
# Run Pokemon sync manually (syncs first 151 Pokemon by default)
docker compose exec backend rails runner "PokemonSyncJob.perform_now"

# Sync a specific number of Pokemon (e.g., all 1000+)
docker compose exec backend rails runner "PokemonSyncJob.perform_now(limit: 1000)"

# Queue the job to run in background
docker compose exec backend rails runner "PokemonSyncJob.perform_later"

# Check job status via Rails console
docker compose exec backend rails c
# Then in console:
# GoodJob::Job.all                    # List all jobs
# GoodJob::Job.where(finished_at: nil) # Pending jobs
# GoodJob::Job.last                   # Most recent job
```

**Cron Schedule**: The Pokemon sync job runs automatically every 6 hours (`0 */6 * * *`).

**Without Docker:**
```bash
rails runner "PokemonSyncJob.perform_now"
rails runner "PokemonSyncJob.perform_now(limit: 1000)"
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | - |
| `RAILS_ENV` | Environment (development/test/production) | development |
| `DEVISE_JWT_SECRET_KEY` | Secret for JWT signing | - |
| `FRONTEND_URL` | Frontend URL for CORS | http://localhost:3001 |

## Architecture Patterns

1. **Thin Controllers**: Max 5 lines per action, delegate to services
2. **Service Objects**: Complex logic in `app/services/`
3. **API Versioning**: All endpoints under `/api/v1/`
4. **JSON:API Serializers**: Consistent response format
5. **JWT Denylist**: Token revocation support

## Troubleshooting

### "undefined method `devise' for User:Class" Error

This error occurs when `devise-jwt` triggers route reloading before Devise's ORM integration is complete. The fix is the `config/initializers/0_devise_setup.rb` initializer which loads Devise ORM early.

If you encounter this error after modifying initializers:
1. Ensure `0_devise_setup.rb` exists and loads before other initializers (the `0_` prefix ensures alphabetical ordering)
2. Clear the bootsnap cache: `rm -rf tmp/cache`
3. Rebuild Docker containers: `docker compose build --no-cache backend`
