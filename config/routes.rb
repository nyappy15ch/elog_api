Rails.application.routes.draw do
  resources :ideas, only: %i[index create]
end
