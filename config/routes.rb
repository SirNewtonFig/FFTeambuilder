Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  namespace :admin do
    resources :jobs
    resources :skills
    resources :items

    resources :monster_passives
    resources :exclusions
    resources :statuses
    resources :prerequisites
    resources :proficiencies
    resources :innates

    root to: "exclusions#index"
  end

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
    member do
      get :confirm_destroy
      post :publish
      post :shuffle
      post :start
      post :close
    end
    
    resources :submissions, controller: 'events/submissions' do
      member do
        patch :approve
        patch :cut
      end

      collection do
        patch :reorder
        post :import
      end
    end

    resource :memgen, controller: 'events/memgen'
  end

  resources :teams do
    member do
      get :export
      post :clone
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

    resource :memgen, controller: 'teams/memgen'
    
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

  resource :challonge_credentials do
    member do
      get :confirm_destroy
    end
  end

  resources :submissions do
    resources :characters, controller: 'submissions/characters' do
      member do
        get :jp_summary
      end
    end
  end
end
