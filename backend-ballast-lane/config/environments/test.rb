require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false

  # Allow any host in tests
  config.hosts.clear
  config.eager_load = ENV["CI"].present?
  config.consider_all_requests_local = true

  # Caching
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Exceptions
  config.action_dispatch.show_exceptions = :rescuable

  # Mailer
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test

  # Logging
  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
end
