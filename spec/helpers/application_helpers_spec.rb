# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe '.formatted_timestamp' do
    subject(:method) { helper.formatted_timestamp(date) }

    let(:date) { '2020-04-30T08:08:31' }

    it 'returns a proper date format' do
      expect(method).to eq('Thursday 30 April 2020')
    end
  end
end
