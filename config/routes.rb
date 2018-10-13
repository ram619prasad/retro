Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do

      resources :users do
        collection do
          post 'signin', to: 'users#signin'
          post 'signup', to: 'users#signup'
        end

        member do
          get 'profile', to: 'users#show'
          get 'boards', to: 'boards#user_boards'
        end
      end

      resources :boards do
        collection do
          get 'my_boards', to: 'boards#my_boards'
        end
      end

      resources :columns

      resources :action_items
    end
  end
end
