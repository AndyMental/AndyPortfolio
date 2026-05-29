Rails.application.routes.draw do
  root "blogs#index"
  resources :blogs
  get "/sitemap.xml", to: "sitemap#index", defaults: { format: :xml }, as: :sitemap
  get "/robots.txt", to: "robots#show"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end
