Rails.application.routes.draw do
  get 'parser/nokogiri'

  resources :universities
  resources :reports
  get 'welcome/index'

  get '/auswahl/', to: 'reports#auswahl'
  get '/general/', to: 'reports#general'
  get '/firsthalfyear/', to: 'reports#firsthalfyear'

  get '/kommentare/', to: 'reports#comments'

  get '/entries_of_universities', to: 'reports#entries_of_universities'

  get '/allcomments/', to: 'reports#allcomments'

  get '/nokogiri/', to: 'parser#nokogiri'

  get '/philosophieaktuell/', to: 'reports#philosophieaktuell'

  get '/blogger/', to: 'reports#blogger'

  get '/externalposts/', to: 'reports#externalposts'

  post '/addblogger/', to: 'reports#addblogger'

  get '/bloggercsv/', to: 'reports#bloggercsv'

  get '/liebeundgemeinschaft/', to: 'reports#liebeundgemeinschaft'

  root 'reports#auswahl'

  get '/ionic', to: 'ionic#ionic'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
