# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - GET #delete', type: :request do
  subject { get delete_fleets_path }

  context 'correct permissions' do
    let(:no_vrn_path) { fleets_path }

    it_behaves_like 'a vrn required view'
  end

  it_behaves_like 'incorrect permissions'
end
