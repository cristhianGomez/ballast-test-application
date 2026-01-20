# frozen_string_literal: true

# Security headers configuration
# Protects against clickjacking, MIME sniffing, and other common attacks
Rails.application.config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'DENY',
  'X-Content-Type-Options' => 'nosniff',
  'X-XSS-Protection' => '0',
  'Referrer-Policy' => 'strict-origin-when-cross-origin',
  'Permissions-Policy' => 'geolocation=(), microphone=(), camera=()'
}

# Enable HSTS in production for secure transport
if Rails.env.production?
  Rails.application.config.action_dispatch.default_headers['Strict-Transport-Security'] =
    'max-age=31536000; includeSubDomains'
end
