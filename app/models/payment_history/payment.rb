# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Represents the virtual model of the payment history, used in +app/views/payment_history/company_payment_history.html.haml+.
  #
  class Payment
    include ApplicationHelper

    def initialize(data)
      @data = data.transform_keys { |key| key.underscore.to_sym }
    end

    # Returns payment id
    def payment_id
      data[:payment_id]
    end

    # Returns parsed payment date
    def date
      Date.parse(data[:payment_date]).strftime('%d/%m/%Y')
    end

    # Returns payment made by
    def payer_name
      data[:payer_name]
    end

    # Returns Clean Air Zone name
    def caz_name
      data[:caz_name]
    end

    # Returns count of entries
    def entries_count
      data[:entries_count]
    end

    # Returns amount paid
    def total_paid
      data[:total_paid]
    end

    # Returns total amount paid value
    def total_amount_paid
      if unsuccessful?
        'Unsuccessful'
      elsif refunded? || charged_back?
        'Refunded'
      else
        parse_charge(total_paid)
      end
    end

    private

    # Reader for data hash
    attr_accessor :data

    # Returns a boolean, e.g. true
    def refunded?
      data[:is_refunded]
    end

    # Returns a boolean, e.g. true
    def charged_back?
      data[:is_chargedback]
    end

    # Returns a boolean, e.g. true
    def unsuccessful?
      data[:is_unsuccessful]
    end
  end
end
