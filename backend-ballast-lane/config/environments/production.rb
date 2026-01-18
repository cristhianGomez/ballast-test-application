require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  # Caching
  config.action_controller.perform_caching = true
  config.cache_store = :memory_store

  # Logging
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.log_tags = [:request_id]
  config.active_support.deprecation = :notify
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are logged
  config.log_formatter = ::Logger::Formatter.new

  # Active Record
  config.active_record.dump_schema_after_migration = false
end
