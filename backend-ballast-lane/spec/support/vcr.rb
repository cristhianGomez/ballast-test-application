require "vcr"
require "webmock/rspec"

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = false
  config.ignore_localhost = true

  config.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: %i[method uri body]
  }
end
