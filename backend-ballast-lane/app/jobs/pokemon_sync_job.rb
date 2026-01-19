class PokemonSyncJob < ApplicationJob
  queue_as :default

  def perform(limit: 151)
    PokemonSyncService.new.sync_all(limit: limit)
  end
end
