# frozen_string_literal: true

require 'rails_helper'

describe StaticPagesController, type: :request do
  describe 'GET #cookies' do
    subject(:http_request) { get cookies_path }

    it_behaves_like 'a static page'
  end
end
