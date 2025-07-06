Rails.application.routes.draw do
  root "pages#index"
  get "/topics/search", to: "topics#search"
  get "search", to: "pages#search", as: :search
  get "/proxy/image", to: "proxy#image"
end
