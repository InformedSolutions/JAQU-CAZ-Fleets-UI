# frozen_string_literal: true

##
# Controller used to pay by credit card
#
class CreditCardsController < ApplicationController
  ##
  # The page used as a landing point after the GOV.UK payment process.
  #
  # Calls +/payments/:id+ backed endpoint to get payment status
  #
  # Redirects to either success or failure payments path
  #
  # ==== Path
  #     GET /payments/result
  #
  # ==== Params
  # * +payment_id+ - id of the created payment, required in the session
  # * +la_id+ - id of the selected CAZ, required in the session
  def result
    payment_data = helpers.initiated_payment_data
    payment = PaymentStatus.new(payment_data[:payment_id], payment_data[:la_id])
    save_payment_details(payment)
    payment.success? ? redirect_to(success_payments_path) : redirect_to(failure_payments_path)
  end

  private

  # Saves payment details using SessionManipulation::SetPaymentDetails
  def save_payment_details(payment)
    SessionManipulation::SetPaymentDetails.call(session: session,
                                                email: payment.user_email,
                                                payment_reference: payment.payment_reference,
                                                external_id: payment.external_id)
  end
end
