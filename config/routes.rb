Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do

      resources :users do
        collection do
          post 'signin', to: 'users#signin'
          post 'signup', to: 'users#signup'
          get 'profile', to: 'users#profile'
        end
      end

    end
  end
end
