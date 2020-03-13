# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetPaymentId do
  subject(:service) { described_class.call(session: session, params: { payment_id: id }) }

  let(:session) { { new_payment: {} } }
  let(:id) { SecureRandom.uuid }

  it 'sets payment id' do
    service
    expect(session[:new_payment][:payment_id]).to eq(id)
  end
end
