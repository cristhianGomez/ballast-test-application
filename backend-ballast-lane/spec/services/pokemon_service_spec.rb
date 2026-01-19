require "rails_helper"

RSpec.describe PokemonService do
  subject(:service) { described_class.new }

  describe "#list" do
    before do
      create(:pokemon, :bulbasaur)
      create(:pokemon, name: "ivysaur", number: 2, types: ["grass", "poison"])
      create(:pokemon, name: "venusaur", number: 3, types: ["grass", "poison"])
      create(:pokemon, :charmander)
      create(:pokemon, :charmeleon)
    end

    it "returns a list of pokemon" do
      result = service.list(limit: 5, offset: 0)

      expect(result).to be_a(Hash)
      expect(result[:pokemon]).to be_an(Array)
      expect(result[:meta][:count]).to eq(5)
    end

    it "filters by name search" do
      result = service.list(search: "char")

      expect(result[:pokemon].map { |p| p[:name] }).to contain_exactly("charmander", "charmeleon")
      expect(result[:meta][:count]).to eq(2)
    end

    it "filters by number search" do
      result = service.list(search: "1")

      expect(result[:pokemon].map { |p| p[:number] }).to eq([1])
    end

    it "filters by exact number with # prefix" do
      result = service.list(search: "#004")

      expect(result[:pokemon].length).to eq(1)
      expect(result[:pokemon].first[:name]).to eq("charmander")
      expect(result[:pokemon].first[:number]).to eq(4)
    end

    it "filters by exact number with # prefix without leading zeros" do
      result = service.list(search: "#2")

      expect(result[:pokemon].length).to eq(1)
      expect(result[:pokemon].first[:name]).to eq("ivysaur")
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
