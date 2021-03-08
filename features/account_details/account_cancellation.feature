Feature: Primary user account cancellation
  In order to close the organization account
  As a primary user
  I want to see the account cancellation form

  Scenario: Close the account
    Given I visit account cancellation page
    Then I should see 'Why do you want to close the account?'
    When I press 'Close account' button
    Then I should see 'You must choose an answer'
    When I select 'Other'
      And I press 'Close account' button
    Then I should be redirected to Account Closed page
