Feature: Payment History Download
  In order to read the page
  As a user
  I want to download payment history

  Scenario: User downloads payments history
    Given I visit payment history page to download CSV
      Then I should not see 'Request a download link (CSV)' link
    # CAZB-4839: Removed button
    # When I press 'Request a download link (CSV)' link
    # Then I should see 'Preparing your payment history'
    #   And I should see 'Return to payment history' link
    # Then I press 'Return to payment history' link
    #   And I should be on the the Company payment history page

  Scenario: User opens a valid link from an email
    Given I am attempting to download payment history from a valid link
    Then I am redirected do download payment history page

  Scenario: User opens an expired link from an email
    Given I am attempting to download payment history from an expired link
    Then I am redirected to link expired page

  Scenario: User opens a valid link requested for other user
    Given I am attempting to download payment history from other user link
    Then I am redirected to link expired page
