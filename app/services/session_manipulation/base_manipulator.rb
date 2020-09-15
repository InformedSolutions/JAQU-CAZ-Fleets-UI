# frozen_string_literal: true

##
# Module used to improve session management
#
module SessionManipulation
  class BaseManipulator < BaseService
    include PaymentsHelper

    def initialize(session:, params: {})
      @session = session
      @params = params
    end

    private

    attr_reader :session, :params
  end
end
