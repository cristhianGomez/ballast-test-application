FactoryBot.define do
  factory :pokemon do
    sequence(:name) { |n| "pokemon#{n}" }
    sequence(:number) { |n| n }
    image { "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/#{number}.png" }
    types { ["normal"] }
    weight { 100 }
    height { 10 }
    description { "A sample Pokemon for testing purposes." }
    color { "gray" }
    moves { ["tackle", "growl"] }
    base_stats do
      {
        hp: 50,
        attack: 50,
        defense: 50,
        special_attack: 50,
        special_defense: 50,
        speed: 50
      }
    end

    trait :bulbasaur do
      name { "bulbasaur" }
      number { 1 }
      types { ["grass", "poison"] }
      weight { 69 }
      height { 7 }
      description { "A strange seed was planted on its back at birth." }
      color { "green" }
      moves { ["tackle", "vine whip", "razor leaf"] }
      base_stats do
        {
          hp: 45,
          attack: 49,
          defense: 49,
          special_attack: 65,
          special_defense: 65,
          speed: 45
        }
      end
    end

    trait :pikachu do
      name { "pikachu" }
      number { 25 }
      types { ["electric"] }
      weight { 60 }
      height { 4 }
      description { "When several of these Pokemon gather, their electricity could build and cause lightning storms." }
      moves { ["thunder shock", "quick attack", "iron tail"] }
      color { "yellow" }
      base_stats do
        {
          hp: 35,
          attack: 55,
          defense: 40,
          special_attack: 50,
          special_defense: 50,
          speed: 90
        }
      end
    end

    trait :charmander do
      name { "charmander" }
      number { 4 }
      types { ["fire"] }
      weight { 85 }
      height { 6 }
      description { "Obviously prefers hot places. When it rains, steam is said to spout from the tip of its tail." }
      color { "red" }
      moves { ["scratch", "ember", "smokescreen"] }
      base_stats do
        {
          hp: 39,
          attack: 52,
          defense: 43,
          special_attack: 60,
          special_defense: 50,
          speed: 65
        }
      end
    end

    trait :charmeleon do
      name { "charmeleon" }
      number { 5 }
      types { ["fire"] }
      weight { 190 }
      height { 11 }
      description { "When it swings its burning tail, it elevates the temperature to unbearably high levels." }
      moves { ["scratch", "ember", "flamethrower"] }
      color { "red" }
    end
  end
end
