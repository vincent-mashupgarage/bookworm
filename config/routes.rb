Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      # Books
      resources :books do
        get :show_by_slug, on: :collection, path: 'slug/:slug'
      end
      
      # Categories
      resources :categories
      
      # Users
      resources :users
      
      # Orders and Order Items
      resources :orders do
        resources :order_items, except: [:edit, :new]
      end
      
      # Carts and Cart Items
      resources :carts, except: [:index, :edit, :new] do
        delete :clear, on: :member
        resources :cart_items, except: [:edit, :new]
      end
      
      # User-specific cart route
      get 'users/:user_id/cart', to: 'carts#show'
      post 'users/:user_id/cart', to: 'carts#create'
    end
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
