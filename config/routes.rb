# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  scope '/fleets/organisation-account', only: %i[] do
    get 'create-account-name', to: 'organisations#new_name'
    post 'create-account-name', to: 'organisations#create_name'

    get 'email-address-and-password', to: 'organisations#new_password'
    post 'email-address-and-password', to: 'organisations#create_account'

    get 'email_sent', to: 'organisations#email_sent'

    get 'add-users', to: 'users#new'
    post 'add-users', to: 'users#create'
    get 'user-added', to: 'users#show'
    post 'another-user', to: 'users#another_user'

    get 'company-log-in', to: 'sign_in#new'
    post 'company-log-in', to: 'sign_in#create'

    get 'organisation-dashboard', to: 'dashboard#index'
  end
end
