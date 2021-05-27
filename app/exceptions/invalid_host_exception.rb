# frozen_string_literal: true

##
# Raises exception if checked host header was modified.
#
class InvalidHostException < ApplicationException
  ##
  # Initializer method for the class. Calls +super+ method on parent class (ApplicationException)
  #
  def initialize
    super('Invalid host header')
  end
end
