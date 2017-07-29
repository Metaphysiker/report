Rails.application.routes.draw do
  resources :universities
  resources :reports
  get 'welcome/index'

  get '/auswahl/', to: 'reports#auswahl'
  get '/general/', to: 'reports#general'
  get '/firsthalfyear/', to: 'reports#firsthalfyear'

  root 'reports#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
