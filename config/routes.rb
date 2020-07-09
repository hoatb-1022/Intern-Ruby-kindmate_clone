Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get "/about", to: "static_pages#about"
    get "/pricing", to: "static_pages#pricing"
    get "/terms_of_use", to: "static_pages#terms_of_use"
    get "/faqs", to: "static_pages#faqs"
    
    root "static_pages#home"
  end
end
