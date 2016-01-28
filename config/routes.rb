Rails.application.routes.draw do
  namespace :metadata do
    resources :categories do
      resources :properties do
        resources :list_items do
          resources :list_items
        end
      end
      resources :categories
    end

    root to: 'categories#index'
  end

  namespace :my do
    resources :adverts

    root to: 'adverts#index'
  end

  root to: 'adverts#index'
end
