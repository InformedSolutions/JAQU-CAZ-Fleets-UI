# frozen_string_literal: true

##
# Raises exception if email already confirmed.
#
class UserAlreadyConfirmedException < ApplicationException
  ##
  # Initializer method for the class. Calls +super+ method on parent class (ApplicationException)
  #
  # ==== Attributes
  # * +msg+ - string - messaged passed to parent exception
  def initialize(msg = nil)
    super(msg)
  end
end
