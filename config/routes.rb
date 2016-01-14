Rails.application.routes.draw do
  namespace :metadata do
    resources :categories
    resources :properties do
      get 'get_fields_for_subproperties/:property_name' => 'properties#get_fields_for_subproperties', as: :get_fields_for_subproperties, on: :collection
    end

    root to: 'categories#index'
  end

  namespace :my do
    resources :adverts

    root to: 'adverts#index'
  end

  root to: 'adverts#index'
end
