Rails.application.routes.draw do
  post 'meeting/join', :to => 'meeting#join', as: 'join_meeting'
  post 'meeting/create', :to => 'meeting#create', as: 'create_meeting'
  root 'user#new'
  get 'user/new'
  get 'user/show'
  post 'user/create', :to => 'user#create'
  resources :meeting, only: [:index, :show, :new]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
