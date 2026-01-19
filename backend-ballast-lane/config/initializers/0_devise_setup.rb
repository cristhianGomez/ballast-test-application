# frozen_string_literal: true

# This initializer runs early (due to 0_ prefix) to ensure Devise's ORM
# integration is set up before devise-jwt triggers route reloading.
# This prevents "undefined method `devise'" errors on User model.

require "devise"
require "devise/orm/active_record"
