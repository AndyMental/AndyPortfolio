Rails.application.routes.draw do
  get "up" => "up#show"
  root "blogs#index"
  get "about" => "static_pages#about"
  resources :blogs
  get "/sitemap.xml", to: "sitemap#index", defaults: { format: :xml }, as: :sitemap

  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unprocessable_entity", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end
