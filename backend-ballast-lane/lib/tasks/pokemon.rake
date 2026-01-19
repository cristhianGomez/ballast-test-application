namespace :pokemon do
  desc "Sync Pokemon data from PokeAPI"
  task sync: :environment do
    limit = ENV.fetch("LIMIT", 151).to_i
    puts "Syncing #{limit} Pokemon..."
    PokemonSyncService.new.sync_all(limit: limit)
    puts "Done! #{Pokemon.count} Pokemon in database."
  end
end
