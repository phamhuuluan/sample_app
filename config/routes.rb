Rails.application.routes.draw do
  root :to => "static_pages#home"

  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  scope "(:locale)", locale: /en|vi/ do
  end
end
