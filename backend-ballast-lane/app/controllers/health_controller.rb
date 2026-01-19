class HealthController < ApplicationController
  def show
    render_success(
      data: {
        status: "ok",
        timestamp: Time.current.iso8601,
        database: database_connected?
      }
    )
  end

  private

  def database_connected?
    ActiveRecord::Base.connection.active?
  rescue StandardError
    false
  end
end
