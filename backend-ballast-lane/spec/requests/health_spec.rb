# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Health' do
  let(:json_headers) { { 'Accept' => 'application/json' } }

  describe 'GET /health' do
    context 'when database is connected' do
      it 'returns ok status' do
        get '/health', headers: json_headers

        expect(response).to have_http_status(:ok)
      end

      it 'returns success true' do
        get '/health', headers: json_headers

        json = JSON.parse(response.body)
        expect(json['success']).to be true
      end

      it 'returns status ok in data' do
        get '/health', headers: json_headers

        json = JSON.parse(response.body)
        expect(json['data']['status']).to eq('ok')
      end

      it 'returns current timestamp' do
        freeze_time = Time.current
        allow(Time).to receive(:current).and_return(freeze_time)

        get '/health', headers: json_headers

        json = JSON.parse(response.body)
        expect(json['data']['timestamp']).to eq(freeze_time.iso8601)
      end

      it 'returns database status true' do
        get '/health', headers: json_headers

        json = JSON.parse(response.body)
        expect(json['data']['database']).to be true
      end

      it 'does not require authentication' do
        get '/health', headers: json_headers

        expect(response).not_to have_http_status(:unauthorized)
      end
    end

    context 'when database is disconnected' do
      before do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_return(false)
      end

      it 'still returns ok status' do
        get '/health', headers: json_headers

        expect(response).to have_http_status(:ok)
      end

      it 'returns database status false' do
        get '/health', headers: json_headers

        json = JSON.parse(response.body)
        expect(json['data']['database']).to be false
      end
    end

    context 'when database check raises error' do
      before do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_raise(StandardError.new('Connection lost'))
      end

      it 'returns database status false' do
        get '/health', headers: json_headers

        json = JSON.parse(response.body)
        expect(json['data']['database']).to be false
      end
    end
  end
end
