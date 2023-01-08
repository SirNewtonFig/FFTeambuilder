Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "teams#index"

  resources :teams do
    collection do
      patch :update
      get :export
      post :download
    end
  end
  
  resources :characters

  resource :memgen, controller: 'memgen', only: %i{ new create } do
    member do
      post :add_slot
    end
  end
end
