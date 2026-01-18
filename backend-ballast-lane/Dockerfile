FROM ruby:3.2-slim

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    postgresql-client \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Set working directory
WORKDIR /app

# Set environment
ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development:test"

# Install bundler
RUN gem install bundler -v 2.5.0

# Copy Gemfile first for caching
COPY Gemfile ./
RUN bundle lock --add-platform x86_64-linux && \
    bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Copy and setup entrypoint
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Precompile assets (if any) - skip in API mode
RUN bundle exec rake assets:precompile 2>/dev/null || true

# Expose port
EXPOSE 3000

# Set entrypoint and command
ENTRYPOINT ["entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
