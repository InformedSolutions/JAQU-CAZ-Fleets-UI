Feature: Organisations
  In order to read the page
  As a user
  I want to be able to create a company
    And see what account was verified

  Scenario: User wants to create a company
    Given I go to the create account page
      And I should see "Create an account"
      And I should see "Create account" link
    Then I press the Continue
      And I should see "Company name is required"
    Then I enter a company name
      And I press the Continue
    Then I should see "Sign in details"
      And I should see "Create account" link
    Then I press the Continue
      And I should see "Email is required"
      And I should see "Password is required"
      And I should not see "Email is in an invalid format"
      And I should not see "Email confirmation is in an invalid format"
    Then I enter the account details
      And I press the Continue
    Then I should see "Verification email"
      And I should receive verification email
    Then I press "resend the email" link
      And I should see "Verification email"
      And I should receive verification email again

  Scenario: User wants to verify account with valid token
    Given I visit the verification link with a valid token
    Then I should see "Your email address has been verified and your account has been activated."

  Scenario: User wants to verify account with invalid token
    Given I visit the verification link with an invalid token
    Then I should see "Your account verification failed"

  Scenario: User wants to verify account second time
    Given I visit the verification link second time
    Then I should see "Sign in"

  Scenario: User wants to create a company when api returns 422 errors
    Given I go to the create account page
    Then I enter a company name
      And I press the Continue
      And I enter the account details with not uniq email address
      And I press the Continue
    Then I should see "Email already exists"

  Scenario: View email verified page
    Given I navigate to a Dashboard page
    When I go to the email verified page
    Then I should see "Your account has been created"
