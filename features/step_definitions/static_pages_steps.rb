# frozen_string_literal: true

When('I press footer link {string}') do |string|
  within('footer.govuk-footer') do
    click_link string
  end
end
