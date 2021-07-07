# frozen_string_literal: true

shared_examples 'sets cache headers' do
  it 'sets Cache-Control' do
    expect(response.headers['Cache-Control']).to eq('no-store')
  end

  it 'sets Pragma' do
    expect(response.headers['Pragma']).to eq('no-store')
  end

  it 'sets Expires' do
    expect(response.headers['Expires']).to eq('Mon, 01 Jan 1990 00:00:00 GMT')
  end
end
