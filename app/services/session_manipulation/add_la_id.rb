# frozen_string_literal: true

module SessionManipulation
  class AddLaId < BaseManipulator
    def call
      la_id = params['local-authority']
      return if new_payment_data[:la_id] == la_id

      session[:new_payment] = { la_id: la_id }
    end
  end
end
