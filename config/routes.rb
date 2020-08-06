Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"

    get "/about", to: "static_pages#about"
    get "/pricing", to: "static_pages#pricing"
    get "/terms_of_use", to: "static_pages#terms_of_use"
    get "/faqs", to: "static_pages#faqs"

    devise_for :users
    devise_scope :user do
      get "signup", to: "users/registrations#new"
      post "signup", to: "users/registrations#create"

      get "login", to: "users/sessions#new"
      post "login", to: "users/sessions#create"
      delete "logout", to: "users/sessions#destroy"

      get "password_reset", to: "users/passwords#new"
      post "password_reset", to: "users/passwords#create"
      patch "password_reset", to: "users/passwords#update"
      put "password_reset", to: "users/passwords#update"
      get "password_reset/edit", to: "users/passwords#edit", as: "edit_password_reset"
    end

    resources :users, except: [:index, :new, :create]
    resources :account_activations, only: :edit
    resources :campaigns do
      resources :donations, only: [:new, :create]
      resources :comments, only: [:create, :update, :destroy]
    end

    resources :admin, only: :index
    namespace :admin do
      resources :users
      resources :campaigns
    end

    mount Ckeditor::Engine => '/ckeditor'
  end

  default_url_options host: "localhost:3000"
end
