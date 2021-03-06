Rails.application.routes.draw do
  devise_for :users
  get 'persons/profile'

  namespace :metadata do
    resources :categories do
      get 'add_existed'
      get 'remove_link'
      resources :categories
      get 'parent_params'
      put 'update_category_property_position', on: :collection

      resources :properties do
        resources :category_properties
        resources :list_items
        resources :hierarch_list_items do
          resources :hierarch_list_items
        end
      end
    end

    root to: 'categories#index'
  end

  resources :users
  namespace :my do
    resources :adverts do
      get 'get_category_children', on: :collection
    end

    root to: 'adverts#index'
  end

  resources :categories do
    get 'get_hierarch_children', on: :collection
  end

  resources :adverts
  root to: 'categories#index'
end
