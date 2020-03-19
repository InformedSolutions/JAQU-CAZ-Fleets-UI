# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  authenticated(:user) { root 'dashboard#index', as: :authenticated_root }
  devise_scope(:user) { root to: 'devise/sessions#new' }

  get 'sign-out', to: 'sessions#sign_out'

  resources :passwords, only: %i[index create] do
    collection do
      get :reset
      post :reset, to: 'passwords#validate'
      get :email_sent
      get :invalid
      get :success
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

  resources :fleets, only: %i[index create] do
    collection do
      get :submission_method
      post :submission_method, to: 'fleets#submit_method'

      get :first_upload
      get :assign_delete
      get :delete
      post :delete, to: 'fleets#confirm_delete'
    end
  end

  resources :payments, only: :index do
    collection do
      post :local_authority
      get :matrix
      post :matrix, to: 'payments#submit'
      get :clear_search
      get :review
      get :review_details
      get :select_payment_method
      post :select_payment_method, to: 'payments#confirm_payment_method'
      get :confirm_direct_debit, to: 'debits#confirm'
      post :initiate_direct_debit, to: 'debits#initiate'
      get :first_mandate, to: 'debits#first_mandate'
      post :initiate_card_payment
      get :result
      get :success
      get :failure
      get :post_payment_details
      get :cancel_payment
    end
  end

  resources :vehicles, only: [] do
    collection do
      get :enter_details
      post :enter_details, to: 'vehicles#submit_details'
      get :details
      post :confirm_details
      get :exempt
      get :incorrect_details
      get :not_found
    end
  end

  resources :debits, only: %i[index new create] do
    collection do
      get :first
    end
  end

  resources :uploads, only: %i[index create] do
    collection do
      get :processing
      get :download_template
    end
  end

  get :cookies, to: 'static_pages#cookies'
  get :accessibility_statement, to: 'static_pages#accessibility_statement'
  get :dashboard, to: 'dashboard#index'
  get :build_id, to: 'application#build_id'
  get :health, to: 'application#health'

  get :service_unavailable, to: 'errors#server_unavailable'
  match '/404', to: 'errors#not_found', via: :all
  # There is no 422 error page in design systems
  match '/422', to: 'errors#internal_server_error', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/503', to: 'errors#service_unavailable', via: :all
end
