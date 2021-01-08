Rails.application.routes.draw do
  resources :artists do
    '/artists/:artist_id'
    
    resources :songs, only: [:index, :show, :new, :edit]

  end
  resources :songs
end