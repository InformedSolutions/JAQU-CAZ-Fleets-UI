# frozen_string_literal: true

##
# Raises exception if service is not able to create company.
#
class UnableToCreateAccountException < ApplicationException
  # Attribute used internally
  attr_reader :errors_object
  #
  # Initializer method for the class. Calls +super+ method on parent class (ApplicationException).
  #
  # ==== Attributes
  # * +errors_object+ - hash - messaged passed to parent exception
  def initialize(msg = nil)
    super(msg)
  end
end
