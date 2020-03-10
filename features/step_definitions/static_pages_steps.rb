# frozen_string_literal: true

When('I press Cookies link') do
  within('footer.govuk-footer') do
    click_link 'Cookies'
  end
end

When('I press Accessibility statement link') do
  within('footer.govuk-footer') do
    click_link 'Accessibility statement'
  end
end
