require "rails_helper"

RSpec.describe PokemonService do
  subject(:service) { described_class.new }

  describe "#list" do
    context "with VCR cassettes" do
      it "returns a list of pokemon" do
        VCR.use_cassette("pokemon_list") do
          result = service.list(limit: 5, offset: 0)

          expect(result).to be_a(Hash)
          expect(result[:pokemon]).to be_an(Array)
          expect(result[:meta][:count]).to be_a(Integer)
        end
      end
    end

    context "with mocked responses" do
      before do
        allow(Rails.cache).to receive(:fetch).and_call_original
        allow(Rails.cache).to receive(:fetch).with("all_pokemon_list", anything).and_return([
          { name: "bulbasaur", number: 1, url: "https://pokeapi.co/api/v2/pokemon/1/" },
          { name: "ivysaur", number: 2, url: "https://pokeapi.co/api/v2/pokemon/2/" },
          { name: "venusaur", number: 3, url: "https://pokeapi.co/api/v2/pokemon/3/" },
          { name: "charmander", number: 4, url: "https://pokeapi.co/api/v2/pokemon/4/" },
          { name: "charmeleon", number: 5, url: "https://pokeapi.co/api/v2/pokemon/5/" }
        ])
        allow(Rails.cache).to receive(:fetch).with(/pokemon_image_/, anything).and_return("https://example.com/sprite.png")
      end

      it "filters by name search" do
        result = service.list(search: "char")

        expect(result[:pokemon].map { |p| p[:name] }).to eq(["charmander", "charmeleon"])
        expect(result[:meta][:count]).to eq(2)
      end

      it "filters by number search" do
        result = service.list(search: "1")

        expect(result[:pokemon].map { |p| p[:number] }).to eq([1])
      end

      it "sorts by name ascending" do
        result = service.list(sort: "name", order: "asc")

        names = result[:pokemon].map { |p| p[:name] }
        expect(names).to eq(names.sort)
      end

      it "sorts by name descending" do
        result = service.list(sort: "name", order: "desc")

        names = result[:pokemon].map { |p| p[:name] }
        expect(names).to eq(names.sort.reverse)
      end

      it "sorts by number ascending by default" do
        result = service.list

        numbers = result[:pokemon].map { |p| p[:number] }
        expect(numbers).to eq(numbers.sort)
      end

      it "paginates results" do
        result = service.list(limit: 2, offset: 1)

        expect(result[:pokemon].length).to eq(2)
        expect(result[:pokemon].first[:number]).to eq(2)
        expect(result[:meta][:limit]).to eq(2)
        expect(result[:meta][:offset]).to eq(1)
      end

      it "returns pokemon with name, number, and image" do
        result = service.list(limit: 1)

        pokemon = result[:pokemon].first
        expect(pokemon).to have_key(:name)
        expect(pokemon).to have_key(:number)
        expect(pokemon).to have_key(:image)
      end
    end
  end
end
