Rails.application.routes.draw do
  root 'books#index'
  resources :books, only: [:index, :create, :show]
end
