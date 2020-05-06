# frozen_string_literal: true

##
# Raises exception if params are invalid during company creation.
#
class InvalidCompanyCreateException < ApplicationException
  ##
  # Initializer method for the class. Calls +super+ method on parent class (ApplicationException).
  #
  # ==== Attributes
  # * +errors_object+ - hash - messaged passed to parent exception
  def initialize(msg = nil)
    super(msg)
  end
end
