Feature: Account set up
  As an Account Manager
  I want to be able to set up a password when I’ve been invited to join an account
  So that I can log in

  Scenario: I enter matching valid passwords and select continue
    Given I am on the set up account page
      And I have a valid token
      And I have entered a valid password and confirmation
    When I press 'Continue' button
      Then I am taken to the account set up confirmation page

  Scenario: The one where the token is missing or invalid
    Given I am on the set up account page
      And I have an invalid token
      And I have entered a valid password and confirmation
    When I press 'Continue' button
      Then I should see 'Authorisation token is invalid or has expired'

  Scenario: I am not allowed to progress if I don't give a password or confirmation
    Given I am on the set up account page
      When I press 'Continue' button
    Then I should see 'Enter your password'
      And I should see 'Confirm your password'
    Then I provide only password confirmation
      And I press 'Continue' button
    Then I should see 'Enter your password'
      And I should see 'Enter a password and password confirmation that are the same'
    When I provide password only
      And I press 'Continue' button
    Then I should see 'Enter a password and password confirmation that are the same'
      And I should see 'Confirm your password'

  Scenario: The one where the passwords details don’t match
    Given I am on the set up account page
      And I provide passwords that do not match
    When I press 'Continue' button
      Then I should see 'Enter a password and password confirmation that are the same' 3 times

  Scenario: The one where the passwords are not formatted correctly
    Given I am on the set up account page
      And I provide exact but invalid passwords
    When I press 'Continue' button
      Then I should see "Password must be at least 12 characters long, include at least one upper case letter" 3 times