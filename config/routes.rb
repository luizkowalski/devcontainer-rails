Rails.application.routes.draw do
  root "pages#index"
  get "topics/search", to: "topics#search"
  get "topics/refresh", to: "topics#refresh"
  get "/topics/fetch_new", to: "topics#fetch_new"
  get "/proxy_image", to: "proxy#image"
end
