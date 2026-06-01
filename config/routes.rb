Rails.application.routes.draw do
  get "up" => "up#show"
  root "blogs#index"
  get "about" => "static_pages#about"
  resources :blogs
  get "/sitemap.xml", to: "sitemap#index", defaults: { format: :xml }, as: :sitemap
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end
