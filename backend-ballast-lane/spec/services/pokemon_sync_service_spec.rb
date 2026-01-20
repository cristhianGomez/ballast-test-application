# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PokemonSyncService do
  let(:service) { described_class.new }

  let(:pokemon_response) do
    {
      'id' => 1,
      'name' => 'bulbasaur',
      'weight' => 69,
      'height' => 7,
      'sprites' => {
        'front_default' => 'https://example.com/default.png',
        'other' => {
          'official-artwork' => {
            'front_default' => 'https://example.com/official.png'
          }
        }
      },
      'types' => [
        { 'type' => { 'name' => 'grass' } },
        { 'type' => { 'name' => 'poison' } }
      ],
      'stats' => [
        { 'stat' => { 'name' => 'hp' }, 'base_stat' => 45 },
        { 'stat' => { 'name' => 'attack' }, 'base_stat' => 49 },
        { 'stat' => { 'name' => 'defense' }, 'base_stat' => 49 },
        { 'stat' => { 'name' => 'special-attack' }, 'base_stat' => 65 },
        { 'stat' => { 'name' => 'special-defense' }, 'base_stat' => 65 },
        { 'stat' => { 'name' => 'speed' }, 'base_stat' => 45 }
      ],
      'moves' => [
        {
          'move' => { 'name' => 'tackle' },
          'version_group_details' => [
            { 'move_learn_method' => { 'name' => 'level-up' }, 'level_learned_at' => 1 }
          ]
        }
      ]
    }
  end

  let(:species_response) do
    {
      'color' => { 'name' => 'green' },
      'flavor_text_entries' => [
        {
          'flavor_text' => "A strange seed was\nplanted on its\nback at birth.",
          'language' => { 'name' => 'en' }
        }
      ]
    }
  end

  describe '#sync_all' do
    context 'when API calls are successful' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/1')
          .to_return(status: 200, body: pokemon_response.to_json, headers: { 'Content-Type' => 'application/json' })
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon-species/1')
          .to_return(status: 200, body: species_response.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'creates pokemon records' do
        expect do
          service.sync_all(limit: 1)
        end.to change(Pokemon, :count).by(1)
      end

      it 'saves pokemon with correct attributes' do
        service.sync_all(limit: 1)

        pokemon = Pokemon.find_by(number: 1)
        expect(pokemon.name).to eq('bulbasaur')
        expect(pokemon.weight).to eq(69)
        expect(pokemon.height).to eq(7)
        expect(pokemon.color).to eq('green')
        expect(pokemon.types).to eq(%w[grass poison])
      end

      it 'extracts official artwork image' do
        service.sync_all(limit: 1)

        pokemon = Pokemon.find_by(number: 1)
        expect(pokemon.image).to eq('https://example.com/official.png')
      end

      it 'extracts base stats correctly' do
        service.sync_all(limit: 1)

        pokemon = Pokemon.find_by(number: 1)
        expect(pokemon.base_stats['hp']).to eq(45)
        expect(pokemon.base_stats['attack']).to eq(49)
        expect(pokemon.base_stats['defense']).to eq(49)
        expect(pokemon.base_stats['special_attack']).to eq(65)
        expect(pokemon.base_stats['special_defense']).to eq(65)
        expect(pokemon.base_stats['speed']).to eq(45)
      end

      it 'normalizes description text' do
        service.sync_all(limit: 1)

        pokemon = Pokemon.find_by(number: 1)
        expect(pokemon.description).to eq('A strange seed was planted on its back at birth.')
      end

      it 'extracts moves' do
        service.sync_all(limit: 1)

        pokemon = Pokemon.find_by(number: 1)
        expect(pokemon.moves).to be_present
        expect(pokemon.moves.first['name']).to eq('Tackle')
      end
    end

    context 'when pokemon already exists (upsert)' do
      let!(:existing_pokemon) { create(:pokemon, name: 'bulbasaur', number: 1, weight: 50) }

      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/1')
          .to_return(status: 200, body: pokemon_response.to_json, headers: { 'Content-Type' => 'application/json' })
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon-species/1')
          .to_return(status: 200, body: species_response.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'updates existing record instead of creating new' do
        expect do
          service.sync_all(limit: 1)
        end.not_to change(Pokemon, :count)
      end

      it 'updates pokemon attributes' do
        service.sync_all(limit: 1)

        existing_pokemon.reload
        expect(existing_pokemon.weight).to eq(69)
      end
    end

    context 'when pokemon API returns 404' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/1')
          .to_return(status: 404, body: '', headers: {})
      end

      it 'does not create pokemon record' do
        expect do
          service.sync_all(limit: 1)
        end.not_to change(Pokemon, :count)
      end

      it 'logs warning and continues' do
        expect(Rails.logger).not_to receive(:error)
        service.sync_all(limit: 1)
      end
    end

    context 'when API returns 500 error' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/1')
          .to_return(status: 500, body: 'Internal Server Error', headers: {})
      end

      it 'does not create pokemon record' do
        expect do
          service.sync_all(limit: 1)
        end.not_to change(Pokemon, :count)
      end
    end

    context 'when API request times out' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/1')
          .to_timeout
      end

      it 'handles timeout gracefully' do
        expect do
          service.sync_all(limit: 1)
        end.not_to raise_error
      end

      it 'does not create pokemon record' do
        expect do
          service.sync_all(limit: 1)
        end.not_to change(Pokemon, :count)
      end
    end

    context 'when API returns invalid JSON' do
      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/1')
          .to_return(status: 200, body: 'not json', headers: {})
      end

      it 'handles parse error gracefully' do
        expect do
          service.sync_all(limit: 1)
        end.not_to raise_error
      end
    end

    context 'with multiple pokemon' do
      let(:pokemon_2_response) { pokemon_response.merge('id' => 2, 'name' => 'ivysaur') }

      before do
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/1')
          .to_return(status: 200, body: pokemon_response.to_json, headers: { 'Content-Type' => 'application/json' })
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon-species/1')
          .to_return(status: 200, body: species_response.to_json, headers: { 'Content-Type' => 'application/json' })
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/2')
          .to_return(status: 200, body: pokemon_2_response.to_json, headers: { 'Content-Type' => 'application/json' })
        stub_request(:get, 'https://pokeapi.co/api/v2/pokemon-species/2')
          .to_return(status: 200, body: species_response.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'syncs multiple pokemon' do
        expect do
          service.sync_all(limit: 2)
        end.to change(Pokemon, :count).by(2)
      end
    end
  end

  describe 'private methods' do
    describe '#extract_image' do
      it 'prefers official artwork' do
        data = pokemon_response
        result = service.send(:extract_image, data)
        expect(result).to eq('https://example.com/official.png')
      end

      it 'falls back to front_default' do
        data = pokemon_response.deep_dup
        data['sprites']['other']['official-artwork']['front_default'] = nil
        result = service.send(:extract_image, data)
        expect(result).to eq('https://example.com/default.png')
      end
    end

    describe '#extract_types' do
      it 'extracts type names from types array' do
        result = service.send(:extract_types, pokemon_response)
        expect(result).to eq(%w[grass poison])
      end

      it 'returns empty array for nil types' do
        result = service.send(:extract_types, { 'types' => nil })
        expect(result).to eq([])
      end
    end

    describe '#extract_base_stats' do
      it 'extracts all stat values' do
        result = service.send(:extract_base_stats, pokemon_response)
        expect(result[:hp]).to eq(45)
        expect(result[:attack]).to eq(49)
        expect(result[:defense]).to eq(49)
        expect(result[:special_attack]).to eq(65)
        expect(result[:special_defense]).to eq(65)
        expect(result[:speed]).to eq(45)
      end

      it 'returns 0 for missing stats' do
        result = service.send(:extract_base_stats, { 'stats' => [] })
        expect(result[:hp]).to eq(0)
      end
    end

    describe '#extract_description' do
      it 'extracts english description' do
        result = service.send(:extract_description, species_response)
        expect(result).to eq('A strange seed was planted on its back at birth.')
      end

      it 'returns nil for nil species data' do
        result = service.send(:extract_description, nil)
        expect(result).to be_nil
      end

      it 'returns nil when no english entry exists' do
        data = { 'flavor_text_entries' => [{ 'language' => { 'name' => 'ja' }, 'flavor_text' => 'Japanese text' }] }
        result = service.send(:extract_description, data)
        expect(result).to be_nil
      end
    end
  end
end
