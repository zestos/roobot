sk_route = '/sidekiq/' + ENV['SIDEKIQ_SECRET']

Roobot::Application.routes.draw do

  require 'sidekiq/web'

  mount Sidekiq::Web => sk_route

  root to: "main#index"
  get  "backup", to: 'main#backup'
  get  "status", to: 'main#status'
  get "oauth/connect", to: 'oauth#connect'
  get "oauth/callback", to: 'oauth#callback'

  get  "dropbox/auth_start"
  get  "dropbox/auth_finish"

  get "logout", to: 'main#logout'

end
