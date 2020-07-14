Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"

    get "/about", to: "static_pages#about"
    get "/pricing", to: "static_pages#pricing"
    get "/terms_of_use", to: "static_pages#terms_of_use"
    get "/faqs", to: "static_pages#faqs"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users, except: :new
    resources :account_activations, only: :edit
    resources :password_resets, except: [:index, :destroy]
    resources :campaigns
  end
end
