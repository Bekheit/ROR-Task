Rails.application.routes.draw do
  namespace 'api' do
    
    match 'applications/:app_token/chats', to: 'chats#index', via: 'get'
    match 'applications/:app_token/chats', to: 'chats#create', via: 'post'

    match 'applications/:app_token/chats/:chat_no/messages', to: 'messages#index', via: 'get'
    match 'applications/:app_token/chats/:chat_no/messages', to: 'messages#create', via: 'post'

    resources :applications
    
    match "users/login", to: "users#login", via: 'post'
    match "users/auto_login", to: "users#auto_login", via: 'get'
    resources :users


  end
end
