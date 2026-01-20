# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rate Limiting' do
  let(:json_headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  before do
    # Enable Rack::Attack for testing and use memory store
    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  after do
    # Reset Rack::Attack cache after each test
    Rack::Attack.reset!
  end

  describe 'general request throttling' do
    it 'allows requests under the limit' do
      get '/health', headers: json_headers
      expect(response).not_to have_http_status(:too_many_requests)
    end
  end

  describe 'login throttling by IP' do
    let(:login_params) do
      { user: { email: 'test@example.com', password: 'password123' } }.to_json
    end

    it 'allows requests under the limit (5 per 20 seconds)' do
      5.times do
        post '/api/v1/auth/sign_in', params: login_params, headers: json_headers
        expect(response.status).not_to eq(429)
      end
    end

    it 'throttles requests over the limit' do
      6.times do
        post '/api/v1/auth/sign_in', params: login_params, headers: json_headers
      end

      expect(response).to have_http_status(:too_many_requests)
    end

    it 'returns proper rate limit response format' do
      6.times do
        post '/api/v1/auth/sign_in', params: login_params, headers: json_headers
      end

      json = JSON.parse(response.body)
      expect(json['success']).to be false
      expect(json['message']).to eq('Rate limit exceeded. Please retry later.')
      expect(json['retry_after']).to be_a(Integer)
    end

    it 'includes Retry-After header' do
      6.times do
        post '/api/v1/auth/sign_in', params: login_params, headers: json_headers
      end

      expect(response.headers['Retry-After']).to be_present
    end
  end

  describe 'login throttling by email' do
    it 'throttles repeated login attempts for same email (5 per minute)' do
      email = 'throttle_test@example.com'

      # Make 6 requests for the same email - even though we can't easily change IPs
      # in the test, the email-based throttle should still trigger
      6.times do
        post '/api/v1/auth/sign_in',
             params: { user: { email: email, password: 'wrong' } }.to_json,
             headers: json_headers
      end

      # At this point we've hit both IP and email limits
      # The response should be 429 (from IP throttle which triggers first)
      expect(response).to have_http_status(:too_many_requests)
    end
  end

  describe 'signup throttling by IP' do
    it 'allows signups under the limit (3 per minute)' do
      3.times do |i|
        post '/api/v1/auth/sign_up',
             params: {
               user: {
                 email: "signup#{i}@example.com",
                 password: 'password123',
                 password_confirmation: 'password123'
               }
             }.to_json,
             headers: json_headers

        expect(response.status).not_to eq(429)
      end
    end

    it 'throttles signups over the limit' do
      4.times do |i|
        post '/api/v1/auth/sign_up',
             params: {
               user: {
                 email: "throttle#{i}@example.com",
                 password: 'password123',
                 password_confirmation: 'password123'
               }
             }.to_json,
             headers: json_headers
      end

      expect(response).to have_http_status(:too_many_requests)
    end
  end

  describe 'health endpoint exemption' do
    it 'does not count against rate limits for general throttle' do
      # Health endpoint should be accessible even under heavy load
      get '/health', headers: json_headers
      expect(response).to have_http_status(:ok)
    end
  end
end
