# frozen_string_literal: true

module Helpers
  # Reads provided file from +spec/fixtures/responses+ directory
  def read_response(filename)
    JSON.parse(File.read("spec/fixtures/responses/#{filename}"))
  end

  def expect_path(path)
    expect(page).to have_current_path(path)
  end
end

World(Helpers)
