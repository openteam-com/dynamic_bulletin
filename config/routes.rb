Rails.application.routes.draw do
  namespace :metadata do
    resources :categories

    root to: 'categories#index'
  end
end
