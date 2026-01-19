require "rails_helper"

RSpec.describe PokemonDetailService do
  subject(:service) { described_class.new }

  describe "#find" do
    context "when pokemon exists" do
      let!(:bulbasaur) { create(:pokemon, :bulbasaur) }
      let!(:pikachu) { create(:pokemon, :pikachu) }

      it "returns pokemon details by name" do
        result = service.find("bulbasaur")

        expect(result).to be_a(Hash)
        expect(result[:name]).to eq("bulbasaur")
        expect(result[:number]).to eq(1)
        expect(result[:image]).to be_present
        expect(result[:types]).to include("grass", "poison")
        expect(result[:weight]).to eq(69)
        expect(result[:height]).to eq(7)
        expect(result[:base_stats]).to include(
          hp: 45,
          attack: 49,
          defense: 49
        )
        expect(result[:color]).to eq("green")
        expect(result[:description]).to be_a(String)
      end

      it "returns pokemon by id" do
        result = service.find(25)

        expect(result).to be_a(Hash)
        expect(result[:name]).to eq("pikachu")
        expect(result[:number]).to eq(25)
      end

      it "returns pokemon by string id" do
        result = service.find("25")

        expect(result).to be_a(Hash)
        expect(result[:name]).to eq("pikachu")
        expect(result[:number]).to eq(25)
      end
    end

    context "when pokemon does not exist" do
      it "returns nil for non-existent name" do
        result = service.find("not-a-pokemon")

        expect(result).to be_nil
      end

      it "returns nil for non-existent id" do
        result = service.find(99999)

        expect(result).to be_nil
      end
    end
  end
end
