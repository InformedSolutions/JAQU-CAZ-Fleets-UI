# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  authenticated(:user) { root 'dashboard#index', as: :authenticated_root }
  devise_scope(:user) { root to: 'devise/sessions#new' }

  get 'sign-out', to: 'sessions#sign_out'

  resources :passwords, only: %i[] do
    collection do
      get :reset
      post :reset, to: 'passwords#validate'
    end
  end

  resources :organisations, only: %i[] do
    collection do
      get :new
      post :new, to: 'organisations#set_name'
      get :new_credentials
      post :new_credentials, to: 'organisations#create'

      get :email_sent
      get :resend_email
      get :email_verified
      get :email_verification
      get :verification_failed
    end
  end

  scope '/fleets/organisation-account', only: %i[] do
    get 'add-users', to: 'users#new'
    post 'add-users', to: 'users#create'
    get 'delete-user', to: 'users#delete'
    post 'another-user', to: 'users#another_user'

    get 'dashboard', to: 'dashboard#index'
    get 'manage-users', to: 'users#manage'
    post 'manage-users', to: 'users#confirm_manage'
  end

  scope '/fleets/single-user', only: %i[] do
    get 'csv-upload', to: 'users#upload'
    get 'first-upload', to: 'users#payment'
    get 'select-direct-debit', to: 'users#caz_selection'
    get 'email-invite', to: 'users#email_invite'
  end

  get :build_id, to: 'application#build_id'
  get :health, to: 'application#health'
end
