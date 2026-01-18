Rails.application.routes.draw do
  # Health check endpoint
  get "health", to: "health#show"

  # Devise routes for API authentication
  devise_for :users,
             path: "api/v1/auth",
             path_names: {
               sign_in: "sign_in",
               sign_out: "sign_out",
               registration: "sign_up"
             },
             controllers: {
               sessions: "api/v1/sessions",
               registrations: "api/v1/registrations"
             }

  # API routes
  namespace :api do
    namespace :v1 do
      resources :pokemon, only: %i[index show]
    end
  end
end
