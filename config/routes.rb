Rails.application.routes.draw do
  post 'meeting/join', :to => 'meeting#join', as: 'join_meeting'
  post 'meeting/create', :to => 'meeting#create', as: 'create_meeting'
  get 'meeting/enter/:id', :to => 'meeting#enter', as: 'enter_meeting'
  root 'user#new'
  get 'user/new'
  get 'user/show'
  post 'user/create', :to => 'user#create'
  resources :meeting, only: [:index, :show, :new]
  
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
