Scapp::Application.routes.draw do
  resources :variable_fields
  post '/variable_fields/add_category', to: 'variable_fields#add_category', as: 'variable_fields_add_new_category'

  resources :variable_field_categories

  resources :variable_field_user_levels

  resources :variable_field_sports

  resources :variable_field_optimal_values

  resources :variable_field_measurements

  resources :user_relations

  resources :organizations

  resources :user_groups

  # static routes
  get '/static/:action', to: 'static#:action'

  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "registrations"}, skip: :sessions
  as :user do
    get 'signin' => 'sessions#new', :as => :new_user_session
    post 'signin' => 'sessions#create', :as => :user_session
    delete 'signout' => 'sessions#destroy', :as => :destroy_user_session
    get 'signout' => 'sessions#destroy', :as => :destroy_user_session_get

  end

  resources :users do
    resources :variable_fields, only: [] do
      collection do
        get '/' => 'variable_fields#user_variable_fields'
      end
      member do
        get 'graph' => 'variable_fields#user_variable_graph'
        get 'table' => 'variable_fields#user_variable_table'
        get 'detail' => 'variable_fields#user_variable_field_detail'
      end
    end

    resources :user_groups, only: [], path: 'groups' do
      collection do
        get '/' => 'user_groups#user_in'
      end
    end

    resources :user_relations, only: [], path: 'relations' do
      collection do
        get '/' => 'user_relations#user_has'
      end
    end

  end
end