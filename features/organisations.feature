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

  Scenario: User wants to verify account with valid token
    Given I visit the verification link with a valid token
    Then I should see "Your email address has been verified and your account has been activated."

  Scenario: User wants to verify account with invalid token
    Given I visit the verification link with an invalid token
    Then I should see "Your account verification failed"
    
