CommingSoon::Application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'devise/sessions/sign_out' => 'devise/sessions#destroy', :as => :destroy_session
    match 'devise/registrations/:id/edit' => 'devise/registrations#edit', :as => :edit_user, :via => :get
    match 'users/:id/edit' => 'users#edit', :as => :edit_admin_user, :via => :get
  end
  resources :users do
    collection do
      delete 'destroy_multiple'
    end
  end

  resources :schema_migrations do
    collection do
      delete 'destroy_multiple'
    end
  end

  get "global/search"
  get "global/filter"
  resources :global do
    get :autocomplete, :on => :collection
  end

  get '/custom_scaffolds/add_reference_column'
  get '/custom_scaffolds/generate_random_data'
  get '/custom_scaffolds/rebuild_entire_application'
  get '/custom_scaffolds/get_last_scaffold_created'  
  resources :custom_scaffolds do
    collection do
      delete 'destroy_multiple'
    end
  end
  
  resources :column_attributes do
    collection do
      delete 'destroy_multiple'
    end
  end
  
  resources :permissions do
    collection do
      delete 'destroy_multiple'
    end
  end
  
  resources :roles do
    collection do 
      delete 'destroy_multiple'
    end
  end

  get "development_tools/erd"  
  get "development_tools/index"
  get "/ajax_calls/validates_scaffold_name"
  get "/ajax_calls/get_column_attributes"
  get "/ajax_calls/get_private_keys"
  get "/ajax_calls/get_foreign_keys"
  get "/ajax_calls/get_has_many_models" 
  get "welcome/index"
  get "welcome/warnings"
  match 'welcome/index' => 'welcome#index', :as => :welcome, :via => :get
  root 'welcome#index'

end
