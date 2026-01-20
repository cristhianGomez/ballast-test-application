# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PokemonSyncJob do
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#perform' do
    let(:sync_service) { instance_double(PokemonSyncService) }

    before do
      allow(PokemonSyncService).to receive(:new).and_return(sync_service)
      allow(sync_service).to receive(:sync_all)
    end

    it 'instantiates PokemonSyncService' do
      expect(PokemonSyncService).to receive(:new)

      described_class.perform_now
    end

    it 'calls sync_all with default limit of 151' do
      expect(sync_service).to receive(:sync_all).with(limit: 151)

      described_class.perform_now
    end

    it 'accepts custom limit parameter' do
      expect(sync_service).to receive(:sync_all).with(limit: 50)

      described_class.perform_now(limit: 50)
    end

    it 'can be enqueued' do
      expect do
        described_class.perform_later
      end.to have_enqueued_job(described_class)
    end

    it 'uses default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end
