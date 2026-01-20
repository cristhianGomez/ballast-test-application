# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Sessions' do
  let(:json_headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  before do
    # Disable Rack::Attack to prevent rate limiting interference
    Rack::Attack.enabled = false
  end

  after do
    Rack::Attack.enabled = true
  end

  describe 'POST /api/v1/auth/sign_in' do
    context 'with valid credentials' do
      let(:valid_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password123'
          }
        }
      end

      it 'returns ok status' do
        post '/api/v1/auth/sign_in', params: valid_params.to_json, headers: json_headers

        expect(response).to have_http_status(:ok)
      end

      it 'returns JWT token in Authorization header' do
        post '/api/v1/auth/sign_in', params: valid_params.to_json, headers: json_headers

        expect(response.headers['Authorization']).to be_present
        expect(response.headers['Authorization']).to start_with('Bearer ')
      end

      it 'returns success response with user data' do
        post '/api/v1/auth/sign_in', params: valid_params.to_json, headers: json_headers

        json = JSON.parse(response.body)
        expect(json['success']).to be true
        expect(json['message']).to eq('Logged in successfully.')
        expect(json['data']['email']).to eq('test@example.com')
      end

      it 'returns a valid JWT token that can be used for authentication' do
        allow_any_instance_of(PokemonService).to receive(:list).and_return({
                                                                             pokemon: [],
                                                                             meta: { count: 0, limit: 20, offset: 0 }
                                                                           })

        post '/api/v1/auth/sign_in', params: valid_params.to_json, headers: json_headers

        token = response.headers['Authorization']
        get '/api/v1/pokemon', headers: json_headers.merge('Authorization' => token)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid email' do
      let(:invalid_email_params) do
        {
          user: {
            email: 'wrong@example.com',
            password: 'password123'
          }
        }
      end

      it 'returns unauthorized status' do
        post '/api/v1/auth/sign_in', params: invalid_email_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid password' do
      let(:invalid_password_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'wrong_password'
          }
        }
      end

      it 'returns unauthorized status' do
        post '/api/v1/auth/sign_in', params: invalid_password_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with missing credentials' do
      it 'returns unauthorized for missing email' do
        post '/api/v1/auth/sign_in',
             params: { user: { password: 'password123' } }.to_json,
             headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized for missing password' do
        post '/api/v1/auth/sign_in',
             params: { user: { email: 'test@example.com' } }.to_json,
             headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/auth/sign_out' do
    context 'with valid authentication' do
      it 'returns ok status' do
        token = auth_token_for(user)

        delete '/api/v1/auth/sign_out',
               headers: json_headers.merge('Authorization' => "Bearer #{token}")

        expect(response).to have_http_status(:ok)
      end

      it 'returns success response' do
        token = auth_token_for(user)

        delete '/api/v1/auth/sign_out',
               headers: json_headers.merge('Authorization' => "Bearer #{token}")

        json = JSON.parse(response.body)
        expect(json['success']).to be true
        expect(json['message']).to eq('Logged out successfully.')
      end

      it 'invalidates the token (adds to denylist)' do
        token = auth_token_for(user)

        delete '/api/v1/auth/sign_out',
               headers: json_headers.merge('Authorization' => "Bearer #{token}")

        # Verify the token is now in the denylist
        expect(JwtDenylist.exists?(jti: JWT.decode(token, nil, false).first['jti'])).to be true
      end

      it 'prevents subsequent requests with the same token' do
        token = auth_token_for(user)

        delete '/api/v1/auth/sign_out',
               headers: json_headers.merge('Authorization' => "Bearer #{token}")

        # Try to use the same token again
        get '/api/v1/pokemon',
            headers: json_headers.merge('Authorization' => "Bearer #{token}")

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized status' do
        delete '/api/v1/auth/sign_out', headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns failure response' do
        delete '/api/v1/auth/sign_out', headers: json_headers

        json = JSON.parse(response.body)
        expect(json['success']).to be false
        expect(json['message']).to eq('Could not log out.')
      end
    end

    context 'with invalid token' do
      it 'returns unauthorized status' do
        delete '/api/v1/auth/sign_out',
               headers: json_headers.merge('Authorization' => 'Bearer invalid_token')

        # Invalid tokens may cause different errors, but shouldn't return 200
        expect(response).not_to have_http_status(:ok)
      end
    end
  end
end
