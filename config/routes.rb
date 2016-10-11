Rails.application.routes.draw do

  root 'application#go'
  match "*path", to: "application#go", via: :all
end
