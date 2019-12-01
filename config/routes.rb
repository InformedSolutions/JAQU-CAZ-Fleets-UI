# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  authenticated(:user) { root 'dashboard#index', as: :authenticated_root }
  devise_scope(:user) { root to: 'devise/sessions#new' }

  resources :passwords, only: %i[new create]

  scope '/fleets/organisation-account', only: %i[] do
    get 'create-account-name', to: 'organisations#new_name'
    post 'create-account-name', to: 'organisations#create_name'

    get 'email-address-and-password', to: 'organisations#new_email_and_password'
    post 'email-address-and-password', to: 'organisations#create_account'

    get 'email-sent', to: 'organisations#email_sent'
    get 'email-verified', to: 'organisations#email_verified'

    get 'add-users', to: 'users#new'
    post 'add-users', to: 'users#create'
    get 'user-added', to: 'users#show'
    post 'another-user', to: 'users#another_user'

    get 'dashboard', to: 'dashboard#index'
    get 'manage-users', to: 'users#manage'
  end

  scope '/fleets/single-user', only: %i[] do
    get 'csv-upload', to: 'users#upload'
    get 'first-upload', to: 'users#payment'
    get 'select-direct-debit', to: 'users#caz_selection'
  end
end
