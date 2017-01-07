Rails.application.routes.draw do
  mount Jurou::Engine => "/jurou"
  resources :books
end
