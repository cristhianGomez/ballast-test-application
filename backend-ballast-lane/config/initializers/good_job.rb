Rails.application.configure do
  config.good_job.max_threads = 2
  config.good_job.poll_interval = 30
  config.good_job.shutdown_timeout = 25

  if Rails.env.test?
    config.good_job.execution_mode = :inline
    config.good_job.enable_cron = false
  else
    config.good_job.execution_mode = :async
    config.good_job.enable_cron = true
    config.good_job.cron = {
      pokemon_sync: {
        cron: "0 */6 * * *",
        class: "PokemonSyncJob",
        description: "Sync Pokemon data from PokeAPI"
      }
    }
  end
end
