#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Ensure bundle is installed (volume mount may overwrite built gems)
echo "Checking bundle dependencies..."
bundle check || bundle install --jobs 4 --retry 3

# Extract database connection details from DATABASE_URL or use individual vars
if [ -n "$DATABASE_URL" ]; then
  # Parse DATABASE_URL (format: postgres://user:password@host:port/database)
  DB_HOST=$(echo $DATABASE_URL | sed -e 's/.*@//' -e 's/:.*//' -e 's/\/.*//')
  DB_USER=$(echo $DATABASE_URL | sed -e 's/.*:\/\///' -e 's/:.*@.*//')
  DB_PASS=$(echo $DATABASE_URL | sed -e 's/.*:\/\/[^:]*://' -e 's/@.*//')
  DB_NAME=$(echo $DATABASE_URL | sed -e 's/.*\///')
else
  DB_HOST="${DB_HOST:-db}"
  DB_USER="${POSTGRES_USER:-postgres}"
  DB_PASS="${POSTGRES_PASSWORD:-password}"
  DB_NAME="${POSTGRES_DB:-ballast_development}"
fi

# Wait for database to be ready
echo "Waiting for database at $DB_HOST..."
until PGPASSWORD=$DB_PASS psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c '\q' 2>/dev/null; do
  echo "Database is unavailable - sleeping..."
  sleep 2
done

echo "Database is ready!"

# Run database migrations
echo "Running database migrations..."
bundle exec rails db:prepare

# Execute the main command
exec "$@"
