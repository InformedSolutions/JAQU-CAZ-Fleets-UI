# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::ClearVrnSearch do
  subject(:service) do
    described_class.call(session: session)
  end

  let(:session) { { payment_query: { search: 'test' } } }

  before { service }

  it 'clear search variable from session' do
    expect(session[:payment_query][:search]).to be_nil
  end
end
