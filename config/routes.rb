Rails.application.routes.draw do
  # get 'users/auth/discord/callback', to: 'users/omniauth_callbacks#discord'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # Defines the root path route ("/")

  root "dashboard#show"

  resource :dashboard, only: %i{ show}, controller: 'dashboard'

  namespace :guests do
    resources :sessions, only: %i{ create }
  end

  namespace :data do
    resources :items, only: %i{ index } do
      collection do
        get :simplified
      end
    end

    resources :jobs, only: %i{ index } do
      collection do
        get :simplified
      end
    end

    resources :skills, only: %i{ index } do
      collection do
        get :simplified
      end
    end
  
    resources :monster_passives, only: %i{ index } do
      collection do
        get :simplified
      end
    end
  end

  resources :events do
    resources :submissions
  end

  resources :teams do
    member do
      get :metadata
    end

    resources :characters, controller: 'teams/characters' do
      member do
        get :jp_summary
      end

      resource :meta, only: %i{ update }, controller: 'teams/characters/meta'

      resources :items, only: %i{ index }, controller: 'teams/characters/items' do
        collection do
          patch :update
        end
      end

      resources :zodiacs, only: %i{ index }, controller: 'teams/characters/zodiacs' do
        collection do
          patch :update
        end
      end

      resource :job, only: %i{ edit update }, controller: 'teams/characters/job'
      resource :skills, only: %i{ edit update }, controller: 'teams/characters/skills'
      
      resource :ai_values, only: %i{ update }, controller: 'teams/characters/ai_values' do
        patch :clear
        patch :default
      end
    end
    
    resource :lineup, only: %i{ update }, controller: 'teams/lineup'
  end

  resource :memgen, controller: 'memgen', only: %i{ new create } do
    member do
      post :add_slot
    end
  end

  resource :user, only: %i{ destroy } do
    member do
      get :confirm_destroy
    end
  end
end
