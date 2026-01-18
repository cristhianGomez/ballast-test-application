require "rails_helper"

RSpec.describe PokemonService do
  subject(:service) { described_class.new }

  describe "#list" do
    it "returns a list of pokemon" do
      VCR.use_cassette("pokemon_list") do
        result = service.list(limit: 5, offset: 0)

        expect(result).to be_a(Hash)
        expect(result[:pokemon]).to be_an(Array)
        expect(result[:count]).to be_a(Integer)
      end
    end
  end

  describe "#find" do
    it "returns pokemon details by id" do
      VCR.use_cassette("pokemon_detail") do
        result = service.find(1)

        expect(result).to be_a(Hash)
        expect(result[:name]).to eq("bulbasaur")
      end
    end

    it "returns pokemon details by name" do
      VCR.use_cassette("pokemon_detail_name") do
        result = service.find("pikachu")

        expect(result).to be_a(Hash)
        expect(result[:name]).to eq("pikachu")
      end
    end
  end
end
