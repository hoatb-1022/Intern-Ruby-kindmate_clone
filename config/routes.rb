Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  mount API => "/"
  mount GrapeSwaggerRails::Engine => "/swagger"

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"

    get "/about", to: "static_pages#about"
    get "/pricing", to: "static_pages#pricing"
    get "/terms_of_use", to: "static_pages#terms_of_use"
    get "/faqs", to: "static_pages#faqs"

    get "/404", to: "errors#not_found", as: "not_found"
    get "/422", to: "errors#unacceptable", as: "unacceptable"
    get "/500", to: "errors#internal_error", as: "internal_error"

    devise_for :users, skip: %i(omniauth_callbacks session passwords registrations)
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
    resources :campaigns do
      resources :donations, only: [:new, :create]
      resources :comments, only: [:create, :update, :destroy] do
        resources :comments, only: [:create, :update, :destroy]
      end
    end
    resources :donations, only: [:index]
    resources :notifications, only: [:index, :update] do
      post :view_all, on: :collection
    end

    resources :admin, only: :index
    namespace :admin do
      resources :users
      resources :campaigns
    end

    mount Ckeditor::Engine => "/ckeditor"

    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"
  end

  default_url_options host: ENV["default_url"]
end
