# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pokemon do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:pokemon)).to be_valid
    end

    it 'has valid trait factories' do
      expect(build(:pokemon, :bulbasaur)).to be_valid
      expect(build(:pokemon, :pikachu)).to be_valid
      expect(build(:pokemon, :charmander)).to be_valid
    end
  end

  describe 'table name' do
    it 'uses pokemons as table name' do
      expect(described_class.table_name).to eq('pokemons')
    end
  end

  describe 'validations' do
    subject { build(:pokemon) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_uniqueness_of(:number) }
  end

  describe '.search_by_term' do
    let!(:bulbasaur) { create(:pokemon, :bulbasaur) }
    let!(:pikachu) { create(:pokemon, :pikachu) }
    let!(:charmander) { create(:pokemon, :charmander) }
    let!(:charmeleon) { create(:pokemon, :charmeleon) }

    context 'with blank term' do
      it 'returns all pokemon' do
        expect(described_class.search_by_term(nil)).to include(bulbasaur, pikachu, charmander, charmeleon)
        expect(described_class.search_by_term('')).to include(bulbasaur, pikachu, charmander, charmeleon)
        expect(described_class.search_by_term('  ')).to include(bulbasaur, pikachu, charmander, charmeleon)
      end
    end

    context 'with name search' do
      it 'finds pokemon by partial name match (case insensitive)' do
        expect(described_class.search_by_term('bulba')).to include(bulbasaur)
        expect(described_class.search_by_term('BULBA')).to include(bulbasaur)
        expect(described_class.search_by_term('BuLbA')).to include(bulbasaur)
      end

      it 'finds multiple pokemon matching name pattern' do
        results = described_class.search_by_term('char')
        expect(results).to include(charmander, charmeleon)
        expect(results).not_to include(bulbasaur, pikachu)
      end

      it 'returns empty when no match found' do
        expect(described_class.search_by_term('mewtwo')).to be_empty
      end
    end

    context 'with #prefix syntax for exact number match' do
      it 'finds pokemon by exact number' do
        expect(described_class.search_by_term('#1')).to eq([bulbasaur])
        expect(described_class.search_by_term('#25')).to eq([pikachu])
      end

      it 'handles leading zeros in #prefix' do
        expect(described_class.search_by_term('#001')).to eq([bulbasaur])
        expect(described_class.search_by_term('#0025')).to eq([pikachu])
      end

      it 'returns empty for non-existent number' do
        expect(described_class.search_by_term('#999')).to be_empty
      end
    end

    context 'with numeric search' do
      it 'finds pokemon by partial number match' do
        expect(described_class.search_by_term('25')).to include(pikachu)
      end

      it 'matches partial numbers' do
        # Create a pokemon with number 125 to test partial matching
        articuno = create(:pokemon, name: 'articuno', number: 125)
        results = described_class.search_by_term('25')
        expect(results).to include(pikachu, articuno)
      end
    end
  end

  describe '.sorted_by' do
    let!(:bulbasaur) { create(:pokemon, :bulbasaur) }
    let!(:pikachu) { create(:pokemon, :pikachu) }
    let!(:charmander) { create(:pokemon, :charmander) }

    context 'sorting by name' do
      it 'sorts by name ascending by default' do
        result = described_class.sorted_by('name', 'asc')
        expect(result.first).to eq(bulbasaur)
        expect(result.last).to eq(pikachu)
      end

      it 'sorts by name descending' do
        result = described_class.sorted_by('name', 'desc')
        expect(result.first).to eq(pikachu)
        expect(result.last).to eq(bulbasaur)
      end
    end

    context 'sorting by number' do
      it 'sorts by number ascending' do
        result = described_class.sorted_by('number', 'asc')
        expect(result.first).to eq(bulbasaur)
        expect(result.second).to eq(charmander)
        expect(result.last).to eq(pikachu)
      end

      it 'sorts by number descending' do
        result = described_class.sorted_by('number', 'desc')
        expect(result.first).to eq(pikachu)
        expect(result.last).to eq(bulbasaur)
      end
    end

    context 'with invalid parameters' do
      it 'defaults to number sort for invalid sort field' do
        result = described_class.sorted_by('invalid', 'asc')
        expect(result.first).to eq(bulbasaur)
      end

      it 'defaults to ascending order for invalid order value' do
        result = described_class.sorted_by('name', 'invalid')
        expect(result.first).to eq(bulbasaur)
      end
    end
  end
end
