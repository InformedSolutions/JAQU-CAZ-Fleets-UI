# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :request do
  describe 'GET #index' do
    subject(:http_request) { get root_path }

    it 'returns http success' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end
end
