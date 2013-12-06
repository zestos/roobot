Roobot::Application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: "main#index"
  get  "backup", to: 'main#backup'
  get  "status", to: 'main#status'
  get "oauth/connect", to: 'oauth#connect'
  get "oauth/callback", to: 'oauth#callback'

  get  "dropbox/main"
  post "dropbox/upload"
  get  "dropbox/auth_start"
  get  "dropbox/auth_finish"

end
