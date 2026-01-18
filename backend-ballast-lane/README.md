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
│   ├── services/
│   │   └── pokemon_service.rb # PokeAPI integration
│   └── serializers/
│       ├── user_serializer.rb
│       └── pokemon_serializer.rb
├── config/
│   ├── database.yml
│   ├── routes.rb
│   └── initializers/
│       ├── cors.rb           # CORS configuration
│       └── devise.rb         # Devise + JWT config
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
