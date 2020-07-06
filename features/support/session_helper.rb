# frozen_string_literal: true

module SessionHelper
  def add_new_user_to_session
    page.set_rack_session(new_user: { name: 'New User Name', email: 'new_user@example.com' })
  end
end

World(SessionHelper)
