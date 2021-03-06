Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  root                'static_pages#home'
  get    'about'   => 'static_pages#about'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users do
    member do
      post :codeforces_problems
      get :search_problems
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :problems,            only: [:new, :create, :edit, :update, :destroy]
end
