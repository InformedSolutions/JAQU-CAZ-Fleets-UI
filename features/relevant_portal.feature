Feature: Relevant portal
  In order to read choose relevant portal
  As a user
  I want to fill the form

  Scenario: User has multiple vehicles to check
    Given I am on the Relevant portal form page
    Then I should see 'What would you like to do?'
      When I press 'Continue' button
    Then I should see 'You must choose an answer'
      And I choose 'Check multiple vehicles'
      And I press 'Continue' button
    Then I should be on the Root path