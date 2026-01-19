require "rails_helper"

RSpec.describe "Api::V1::Pokemon" do
  let(:user) { create(:user) }
  let(:json_headers) { { "Accept" => "application/json" } }

  describe "GET /api/v1/pokemon" do
    context "without authentication" do
      it "returns unauthorized" do
        get "/api/v1/pokemon", headers: json_headers

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json["success"]).to be false
      end
    end

    context "with authentication" do
      before do
        allow_any_instance_of(PokemonService).to receive(:list).and_return({
          pokemon: [
            { name: "bulbasaur", number: 1, image: "https://example.com/1.png" },
            { name: "ivysaur", number: 2, image: "https://example.com/2.png" }
          ],
          meta: {
            count: 1000,
            limit: 20,
            offset: 0
          }
        })
      end

      it "returns a list of pokemon" do
        get "/api/v1/pokemon", headers: auth_headers_for(user).merge(json_headers)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["success"]).to be true
        expect(json["data"]).to be_an(Array)
        expect(json["data"].length).to eq(2)
        expect(json["meta"]["count"]).to eq(1000)
      end

      it "accepts search parameter" do
        expect_any_instance_of(PokemonService).to receive(:list).with(
          hash_including(search: "bulba")
        ).and_return({
          pokemon: [{ name: "bulbasaur", number: 1, image: nil }],
          meta: { count: 1, limit: 20, offset: 0 }
        })

        get "/api/v1/pokemon",
            params: { search: "bulba" },
            headers: auth_headers_for(user).merge(json_headers)

        expect(response).to have_http_status(:ok)
      end

      it "accepts sort and order parameters" do
        expect_any_instance_of(PokemonService).to receive(:list).with(
          hash_including(sort: "name", order: "desc")
        ).and_return({
          pokemon: [],
          meta: { count: 0, limit: 20, offset: 0 }
        })

        get "/api/v1/pokemon",
            params: { sort: "name", order: "desc" },
            headers: auth_headers_for(user).merge(json_headers)

        expect(response).to have_http_status(:ok)
      end

      it "accepts limit and offset parameters" do
        expect_any_instance_of(PokemonService).to receive(:list).with(
          hash_including(limit: 10, offset: 5)
        ).and_return({
          pokemon: [],
          meta: { count: 0, limit: 10, offset: 5 }
        })

        get "/api/v1/pokemon",
            params: { limit: 10, offset: 5 },
            headers: auth_headers_for(user).merge(json_headers)

        expect(response).to have_http_status(:ok)
      end
    end

    context "when service fails" do
      before do
        allow_any_instance_of(PokemonService).to receive(:list).and_return(nil)
      end

      it "returns service unavailable" do
        get "/api/v1/pokemon", headers: auth_headers_for(user).merge(json_headers)

        expect(response).to have_http_status(:service_unavailable)
        json = JSON.parse(response.body)
        expect(json["success"]).to be false
        expect(json["message"]).to eq("Failed to fetch Pokemon list")
      end
    end
  end

  describe "GET /api/v1/pokemon/:id" do
    context "without authentication" do
      it "returns unauthorized" do
        get "/api/v1/pokemon/bulbasaur", headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with authentication" do
      it "returns pokemon details" do
        allow_any_instance_of(PokemonDetailService).to receive(:find).with("bulbasaur").and_return({
          name: "bulbasaur",
          number: 1,
          image: "https://example.com/1.png",
          types: ["grass", "poison"],
          weight: 69,
          height: 7,
          description: "A strange seed was planted on its back at birth.",
          base_stats: {
            hp: 45,
            attack: 49,
            defense: 49,
            special_attack: 65,
            special_defense: 65,
            speed: 45
          },
          color: "green"
        })

        get "/api/v1/pokemon/bulbasaur", headers: auth_headers_for(user).merge(json_headers)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["success"]).to be true
        expect(json["data"]["name"]).to eq("bulbasaur")
        expect(json["data"]["types"]).to eq(["grass", "poison"])
        expect(json["data"]["color"]).to eq("green")
        expect(json["data"]["description"]).to be_present
      end

      it "returns 404 when pokemon not found" do
        allow_any_instance_of(PokemonDetailService).to receive(:find).with("not-a-pokemon").and_return(nil)

        get "/api/v1/pokemon/not-a-pokemon", headers: auth_headers_for(user).merge(json_headers)

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["success"]).to be false
        expect(json["message"]).to eq("Pokemon not found")
      end
    end
  end
end
