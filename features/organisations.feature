Feature: Organisations
  In order to read the page
  As a user
  I want to be able to create a company
    And see what account was verified

  Scenario: User wants to create a company
    Given I go to the create account page
      And I should see "Create account"
    Then I enter a company name
      And I press the Continue
    Then I should see "Account details"
      And I enter the account details
      And I press the Continue
    Then I should see "Verification email"
      And I should receive verification email

  Scenario: View email verified page
    Given I am on the root page
    When I go to the email verified page
    Then I should see "Your account has been created"
