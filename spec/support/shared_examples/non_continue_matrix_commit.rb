# frozen_string_literal: true

RSpec.shared_examples 'a non continue matrix commit' do
  it 'redirects to :matrix' do
    expect(http_request).to redirect_to(matrix_payments_path)
  end

  it 'saves new payment data' do
    http_request
    expect(session[:new_payment][:details][@vrn]).to eq(dates)
  end

  it 'saves search data' do
    http_request
    expect(session[:payment_query][:search]).to eq(search)
  end
end
