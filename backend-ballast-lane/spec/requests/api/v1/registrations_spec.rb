# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Registrations' do
  let(:json_headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

  before do
    # Disable Rack::Attack to prevent rate limiting interference
    Rack::Attack.enabled = false
  end

  after do
    Rack::Attack.enabled = true
  end

  describe 'POST /api/v1/auth/sign_up' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'creates a new user' do
        expect do
          post '/api/v1/auth/sign_up', params: valid_params.to_json, headers: json_headers
        end.to change(User, :count).by(1)
      end

      it 'returns created status' do
        post '/api/v1/auth/sign_up', params: valid_params.to_json, headers: json_headers

        expect(response).to have_http_status(:created)
      end

      it 'returns JWT token in Authorization header' do
        post '/api/v1/auth/sign_up', params: valid_params.to_json, headers: json_headers

        expect(response.headers['Authorization']).to be_present
        expect(response.headers['Authorization']).to start_with('Bearer ')
      end

      it 'returns success response with user data' do
        post '/api/v1/auth/sign_up', params: valid_params.to_json, headers: json_headers

        json = JSON.parse(response.body)
        expect(json['success']).to be true
        expect(json['message']).to eq('Signed up successfully.')
        expect(json['data']['email']).to eq('newuser@example.com')
      end
    end

    context 'with missing email' do
      let(:params_without_email) do
        {
          user: {
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/auth/sign_up', params: params_without_email.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns validation errors' do
        post '/api/v1/auth/sign_up', params: params_without_email.to_json, headers: json_headers

        json = JSON.parse(response.body)
        expect(json['success']).to be false
        expect(json['errors']).to include("Email can't be blank")
      end
    end

    context 'with duplicate email' do
      let!(:existing_user) { create(:user, email: 'existing@example.com') }
      let(:duplicate_params) do
        {
          user: {
            email: 'existing@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/auth/sign_up', params: duplicate_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns email taken error' do
        post '/api/v1/auth/sign_up', params: duplicate_params.to_json, headers: json_headers

        json = JSON.parse(response.body)
        expect(json['success']).to be false
        expect(json['errors']).to include('Email has already been taken')
      end
    end

    context 'with password mismatch' do
      let(:mismatched_params) do
        {
          user: {
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'different_password'
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/auth/sign_up', params: mismatched_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns password confirmation error' do
        post '/api/v1/auth/sign_up', params: mismatched_params.to_json, headers: json_headers

        json = JSON.parse(response.body)
        expect(json['success']).to be false
        expect(json['errors']).to include("Password confirmation doesn't match Password")
      end
    end

    context 'with password too short' do
      let(:short_password_params) do
        {
          user: {
            email: 'newuser@example.com',
            password: '123',
            password_confirmation: '123'
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/auth/sign_up', params: short_password_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns password length error' do
        post '/api/v1/auth/sign_up', params: short_password_params.to_json, headers: json_headers

        json = JSON.parse(response.body)
        expect(json['success']).to be false
        expect(json['errors'].any? { |e| e.include?('Password is too short') }).to be true
      end
    end

    context 'with invalid email format' do
      let(:invalid_email_params) do
        {
          user: {
            email: 'not-an-email',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/auth/sign_up', params: invalid_email_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns email invalid error' do
        post '/api/v1/auth/sign_up', params: invalid_email_params.to_json, headers: json_headers

        json = JSON.parse(response.body)
        expect(json['success']).to be false
        expect(json['errors']).to include('Email is invalid')
      end
    end
  end
end
