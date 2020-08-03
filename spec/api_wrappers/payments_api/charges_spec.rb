# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.charges' do
  subject { PaymentsApi.charges(account_id: id, page: page) }

  let(:id) { @uuid }
  let(:page) { 5 }

  before do
    stub_request(:get, %r{accounts/#{id}/charges}).to_return(
      status: 200,
      body: read_unparsed_response('charges.json')['1']
    )
  end

  it 'calls API with proper query data' do
    subject
    expect(WebMock).to have_requested(
      :get,
      %r{accounts/#{id}/charges\?pageNumber=#{page - 1}&pageSize=10}
    )
  end

  context 'with per_page' do
    subject { PaymentsApi.charges(account_id: id, page: page, per_page: per_page) }

    let(:per_page) { 25 }

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(
        :get,
        %r{accounts/#{id}/charges\?pageNumber=#{page - 1}&pageSize=#{per_page}}
      )
    end
  end

  context 'with zones' do
    subject { PaymentsApi.charges(account_id: id, page: page, zones: zones) }

    let(:zones) { [@uuid, @uuid] }

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(
        :get,
        %r{accounts/#{id}/charges\?pageNumber=#{page - 1}&pageSize=10&zones=#{zones.join(',')}}
      )
    end
  end
end
