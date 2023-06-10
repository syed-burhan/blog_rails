Rails.application.routes.draw do

  # get '/posts/search', to: 'posts#search', as: 'search_posts'
  resources :posts do
  	resources :comments
  end

  # Defines the root path route ("/")
  root "posts#index"
end
