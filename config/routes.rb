Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "teams#index"

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

  resources :teams do
    collection do
      patch :update
      get :export
      post :download

      resource :lineup, only: %i{ update }, controller: 'teams/lineup'
    end
  end
  
  resources :characters do
    member do
      get :jp_summary
    end

    resource :meta, only: %i{ update }, controller: 'characters/meta'

    resources :items, only: %i{ index }, controller: 'characters/items' do
      collection do
        patch :update
      end
    end

    resources :zodiacs, only: %i{ index }, controller: 'characters/zodiacs' do
      collection do
        patch :update
      end
    end

    resource :job, only: %i{ edit update }, controller: 'characters/job'
    resource :skills, only: %i{ edit update }, controller: 'characters/skills'
    
    resource :ai_values, only: %i{ update }, controller: 'characters/ai_values' do
      patch :clear
      patch :default
    end
  end

  resource :memgen, controller: 'memgen', only: %i{ new create } do
    member do
      post :add_slot
    end
  end
end
