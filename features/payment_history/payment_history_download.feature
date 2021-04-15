Feature: Payment History Download
  In order to read the page
  As a user
  I want to download payment history

  Scenario: User downloads payments history
    # TODO: Initiation of download should be added here
    Given I start download payments history process
      And I should see 'Downloading your payment history'
      And I should see 'Return to payment history' link
    Then I press 'Return to payment history' link
      And I should be on the the Company payment history page
