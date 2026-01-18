require "rails_helper"

RSpec.describe "Api::V1::Pokemon" do
  describe "GET /api/v1/pokemon" do
    it "returns a list of pokemon" do
      allow_any_instance_of(PokemonService).to receive(:list).and_return({
        pokemon: [
          { id: 1, name: "bulbasaur", types: ["grass", "poison"] },
          { id: 2, name: "ivysaur", types: ["grass", "poison"] }
        ],
        count: 1000,
        next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
        previous: nil
      })

      get "/api/v1/pokemon", params: { limit: 20, offset: 0 }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["success"]).to be true
      expect(json["data"]).to be_an(Array)
      expect(json["data"].length).to eq(2)
    end
  end

  describe "GET /api/v1/pokemon/:id" do
    it "returns pokemon details" do
      allow_any_instance_of(PokemonService).to receive(:find).with("1").and_return({
        id: 1,
        name: "bulbasaur",
        height: 7,
        weight: 69,
        types: ["grass", "poison"]
      })

      get "/api/v1/pokemon/1"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["success"]).to be true
      expect(json["data"]["name"]).to eq("bulbasaur")
    end

    it "returns 404 when pokemon not found" do
      allow_any_instance_of(PokemonService).to receive(:find).with("9999").and_return(nil)

      get "/api/v1/pokemon/9999"

      expect(response).to have_http_status(:not_found)
    end
  end
end
