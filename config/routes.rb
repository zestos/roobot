Roobot::Application.routes.draw do

  root to: "main#index"

  get  "dropbox/main"
  post "dropbox/upload"
  get  "dropbox/auth_start"
  get  "dropbox/auth_finish"

end
