Rails.application.routes.draw do
  namespace :metadata do
    resources :categories

    root to: 'categories#index'
  end

  namespace :my do
    resources :adverts

    root to: 'adverts#index'
  end

  root to: 'adverts#index'
end
