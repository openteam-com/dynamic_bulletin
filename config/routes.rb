Rails.application.routes.draw do
  namespace :metadata do
    resources :categories do
      resources :categories
      get 'update_property_position', on: :collection

      resources :properties do
        resources :list_items do
          resources :list_items
        end
      end
    end

    root to: 'categories#index'
  end

  namespace :my do
    resources :adverts do
      get 'get_category_children', on: :collection
    end

    root to: 'adverts#index'
  end

  resources :adverts
  root to: 'adverts#index'
end
