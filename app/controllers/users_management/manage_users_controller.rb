# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Controller used to manage users
  #
  class ManageUsersController < ApplicationController
    include CheckPermissions
    include UsersHelper
    before_action -> { check_permissions(allow_manage_users?) }
    before_action -> { not_own_account?(account_user_id) }, only: %i[edit update]
    rescue_from BaseApi::Error404Exception, with: :user_not_found

    ##
    # Renders the manage user permissions page
    #
    # ==== Path
    #
    #    GET /users/:id/edit
    #
    def edit
      api_response = AccountsApi.user(account_id: current_user.account_id, account_user_id: account_user_id)
      SessionManipulation::SetEditUser.call(session: session, params: api_response)
      @user = UsersManagement::EditUser.new(api_response, account_user_id)
    end

    ##
    # Validates user input and call api to update user permissions
    #
    # ==== Path
    #
    #    PATCH /users/:id/update
    #
    def update
      form = UsersManagement::EditUserForm.new(
        account_id: current_user.account_id,
        account_user_id: account_user_id,
        permissions: params.dig(:edit_user, 'permissions')
      )
      handle_edit_user_form(form)
    end

    ##
    # Renders the user removal confirmation page
    #
    # ==== Path
    #
    #    GET /users/:id/delete
    #
    def delete
      @back_button_url = edit_user_path(account_user_id)
      @user_full_name = session.dig(:edit_user, 'name')
    end

    private

    # Validates user input and calls api to update the user permissions
    def handle_edit_user_form(form)
      if form.valid?
        form.submit
        redirect_to users_path
      else
        flash[:errors] = form.error_message
        redirect_to edit_user_path
      end
    end

    # account_user_id from params
    def account_user_id
      params['id']
    end

    # Redirects to {not_found page}[rdoc-ref:ErrorsController.not_found]
    def user_not_found
      redirect_to not_found_path
    end
  end
end
