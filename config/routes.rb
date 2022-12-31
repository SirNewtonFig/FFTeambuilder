Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "teams#index"

  resources :teams do
    member do
      get :download
    end
  end
  
  resources :characters
end
