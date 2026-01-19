# Rate limiting configuration
class Rack::Attack
  # Throttle all requests by IP (300 requests per 5 minutes)
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?("/assets")
  end

  # Throttle login attempts by IP (5 requests per 20 seconds)
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == "/api/v1/auth/sign_in" && req.post?
  end

  # Throttle login attempts by email (5 requests per minute)
  throttle("logins/email", limit: 5, period: 60.seconds) do |req|
    if req.path == "/api/v1/auth/sign_in" && req.post?
      req.params.dig("user", "email")&.to_s&.downcase&.strip.presence
    end
  end

  # Throttle signup attempts by IP (3 requests per minute)
  throttle("signups/ip", limit: 3, period: 60.seconds) do |req|
    req.ip if req.path == "/api/v1/auth/sign_up" && req.post?
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |req|
    match_data = req.env["rack.attack.match_data"]
    now = Time.current

    headers = {
      "Content-Type" => "application/json",
      "Retry-After" => (match_data[:period] - (now.to_i % match_data[:period])).to_s
    }

    body = {
      success: false,
      message: "Rate limit exceeded. Please retry later.",
      retry_after: headers["Retry-After"].to_i
    }.to_json

    [429, headers, [body]]
  end
end

# Enable caching for Rack::Attack in production
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new if Rails.env.production?
