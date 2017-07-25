Rails.application.routes.draw do
  resources :universities
  resources :reports
  get 'welcome/index'

  get '/general/', to: 'reports#general'

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end