# frozen_string_literal: true

require 'rails_helper'

describe '.assign_back_button_url', type: :request do
  subject { get enter_details_vehicles_path, headers: { HTTP_REFERER: 'javascript:alert("XSS");' } }

  it 'raises `RefererXssException` exception' do
    sign_in(manage_vehicles_user)
    expect { subject }.to raise_error(RefererXssException)
  end
end
