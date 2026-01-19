Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch("FRONTEND_URL") {
      Rails.env.development? || Rails.env.test? ? "http://localhost:3001" : raise("FRONTEND_URL is required in production")
    }

    resource "/api/*",
             headers: %w[Authorization Content-Type Accept],
             methods: %i[get post put patch delete options head],
             expose: %w[Authorization],
             credentials: true,
             max_age: 600
  end
end
