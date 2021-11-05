Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # scope module: :v1, constraints: ApiVersion.new('v1', true) do
  namespace :api do
    namespace :v1 do
      resources :offers, only: [:index, :show]
      # resources :cart, only: [:show, :update] do
      #   resources :users
      # end
      resources :categories do
        resources :sub_categories
      end
      resources :sub_categories, only: [:show] do
        resources :products, only: [:index, :show]
      end
      resources :products, only: [:index, :show]
      resources :users, only: [:show, :update, :destroy] do
        resources :carts, only:[:create, :index]
      end
      resources :carts, only: [:show, :update, :destroy] do
        resources :orders, only: [:create, :index]
        post 'confirmation', :on => :member
      end
      resources :orders, only: [:show, :update, :destroy]

      namespace :public do
        resources :categories, only: [:index, :show] do
          resources :sub_categories, only: [:index, :show]
        end
        resources :products, only: [:index, :show]
        resources :sub_categories, only: [:show] do
          resources :products, only: [:index, :show]
        end
      end
    end
  end
  # end

  post 'auth/login', to: 'authentication#authenticate'
  # post 'api/v1/carts/:id/confirmation', to: 'cart#confirmation'
  post 'signup', to: 'users#create'
end
