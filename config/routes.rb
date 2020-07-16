# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  authenticated(:user) { root 'dashboard#index', as: :authenticated_root }
  devise_scope(:user) { root to: 'devise/sessions#new' }

  get 'sign-out', to: 'sessions#sign_out_page'
  get 'logout_notice', to: 'sessions#logout_notice'
  get 'timedout-user', to: 'sessions#timedout_user'

  resources :passwords, only: %i[index create] do
    collection do
      get :reset
      post :reset, to: 'passwords#validate'
      get :email_sent
      get :invalid
      get :success
    end
  end

  scope module: 'organisations', path: '/' do
    resources :organisations, only: %i[] do
      collection do
        get :new
        post :new, to: 'organisations#set_name'
        get :fleet_check
        post :fleet_check, to: 'organisations#submit_fleet_check'
        get :cannot_create
        get :new_credentials
        post :new_credentials, to: 'organisations#create'

        get :email_sent
        get :resend_email
        get :email_verified
        get :email_verification
        get :verification_failed
        get :verification_expired
      end
    end
  end

  scope module: 'vehicles_management', path: '/' do
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

    resources :vehicles, only: [] do
      collection do
        get :enter_details
        post :enter_details, to: 'vehicles#submit_details'
        get :details
        post :confirm_details
        get :exempt
        get :incorrect_details
        get :not_found
        post :confirm_not_found
        get :local_exemptions
        post :add_to_fleet
        post :confirm_and_add_exempt_vehicle_to_fleet
      end
    end

    resources :uploads, only: %i[index create] do
      collection do
        get :processing
        get :download_template
      end
    end
  end

  scope module: 'payments', path: '/' do
    resources :payments, only: :index do
      collection do
        post :local_authority
        get :no_chargeable_vehicles
        get :matrix
        post :matrix, to: 'payments#submit'
        get :clear_search
        get :review
        post :confirm_review
        get :review_details
        get :select_payment_method
        post :select_payment_method, to: 'payments#confirm_payment_method'
        get :initiate, to: 'credit_cards#initiate'
        get :result, to: 'credit_cards#result'
        get :success
        get :failure
        get :post_payment_details
        get :cancel, to: '/direct_debits/debits#cancel'
      end
    end
  end

  scope module: 'direct_debits', path: '/' do
    resources :debits, only: %i[index new create] do
      collection do
        get :first_mandate
        get :confirm
        post :initiate
        get :success
      end
    end
  end

  scope module: 'users_management', path: '/' do
    resources :users, only: %w[index new create edit update] do
      collection do
        get :add_permissions
        post :confirm_permissions
        get :confirmation
        get :set_up
        post :confirm_set_up
        get :set_up_confirmation
      end
    end
  end

  get :cookies, to: 'static_pages#cookies'
  get :accessibility_statement, to: 'static_pages#accessibility_statement'
  get :privacy_notice, to: 'static_pages#privacy_notice'
  get :dashboard, to: 'dashboard#index'
  get :build_id, to: 'application#build_id'
  get :health, to: 'application#health'

  get :not_found, to: 'errors#not_found'
  get :service_unavailable, to: 'errors#server_unavailable'

  match '/404', to: 'errors#not_found', via: :all
  # There is no 422 error page in design systems
  match '/422', to: 'errors#internal_server_error', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/503', to: 'errors#service_unavailable', via: :all
end
