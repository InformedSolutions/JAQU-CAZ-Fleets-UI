# frozen_string_literal: true

# Reads provided file from +spec/fixtures/responses+ directory
def read_response(filename)
  JSON.parse(File.read("spec/fixtures/responses/#{filename}"))
end
