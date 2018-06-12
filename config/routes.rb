Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      resources :venues, only: [:new, :create, :show, :index, :update] do 
      	resources :reviews, only: [:create, :index] do
      		resources :vibes, only: [:index]
      	end
        resources :reports, only: [:create],
          path: '/report_inaccurate', to: 'reports#create_inaccurate' #can make another same way
      	# resources :events, only: [:index]
      end

      # resources :events, except: [:destroy] do
      	# resources :comments, only: [:create, :index]
      # end

      resources :games, only: [:index, :create]

		  resources :users, except: [:index, :destroy] do
        resources :favorites, only: [:index]
		  end

		  resources :sessions, only: [:create] do
        delete :destroy, on: :collection
        get :current, on: :collection
      end

      post 'passwords/forgot', to: 'passwords#forgot'
      post 'passwords/reset', to: 'passwords#reset'
      put  'passwords/update', to: 'passwords#update'

      resources :favorites, only: [:index, :create, :destroy]

      resources :contacts, only: [:create]

		  resources :confirm_email, only: [:show], path: '/users/confirm_email'

    end
  end


end
