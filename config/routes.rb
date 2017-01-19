Rails.application.routes.draw do

  resources :wikis

  devise_for :users

  get 'about' => 'welcome#about'

  root 'welcome#index'

  resource :charges, only: [:new, :create] do
    member do
      get 'to_standard'
    end
  end

  resources :wikis do
    resources :collaborators, only: [:new, :create, :destroy]
  end

end
