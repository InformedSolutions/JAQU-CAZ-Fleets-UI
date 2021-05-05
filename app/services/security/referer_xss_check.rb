# frozen_string_literal: true

##
# Module used for security checks.
module Security
  ##
  # Service used to prepare check if refere aws not affected with javascript included in the request.
  # It uses sanitized links with the referer to check if are correct.
  #
  class RefererXssCheck < BaseService
    ##
    # Initializer method.
    #
    # ==== Attributes
    # * +referer+ - string with the request referer.
    #
    def initialize(referer:)
      @referer = referer
    end

    ##
    # The caller method for the service.
    def call
      referer_link = link_with_referer(referer)
      sanitized_referer_link = ActionController::Base.helpers.sanitize(referer_link)
      return if referer_link == sanitized_referer_link

      raise RefererXssException
    end

    private

    # method to create html link tag with referer url
    def link_with_referer(referer)
      ActionController::Base.helpers.link_to 'test', referer
    end

    # Attributes reader
    attr_reader :referer
  end
end
