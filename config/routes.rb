# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  devise_for :users

  scope '/fleets/organisation-account' do
    get 'create-account', to: 'organisation_accounts#new'
    post 'create-account', to: 'organisation_accounts#create'
    get 'account-set-up', to: 'organisation_accounts#show'

    get 'company-email-address', to: 'emails#new'
    post 'company-email-address', to: 'emails#create'

    get 'company-password', to: 'passwords#new'
    post 'company-password', to: 'passwords#create'

    get 'add-users', to: 'users#new'
    post 'add-users', to: 'users#create'
    get 'user-added', to: 'users#show'
    post 'another-user', to: 'users#another_user'

    get 'organisation-dashboard', to: 'dashboard#index'
  end
end
