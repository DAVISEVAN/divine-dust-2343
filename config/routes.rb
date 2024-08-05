Rails.application.routes.draw do
  resources :flights, only: [:index] do
    resources :flight_passengers, only: [:destroy]
  end
end
