Feature: Password update
  As an account user
  I want to be able to update my password
  So that I can change it for security reasons

  Scenario: Password update process as primary user
    Given I navigate to a Dashboard page
      And I should enter fleet owner credentials and press the Continue
    Then I want to see my account details
      And I want to change my password
      And I should be on account details update password page
    When I press 'Save changes' button
      Then I should see 'Enter your old password' 2 times
      Then I should see 'Enter your new password' 2 times
      Then I should see 'Confirm your new password' 2 times
    When I fill invalid old password and press 'Save changes'
      Then I should see 'The password you entered is incorrect' 2 times
    When I fill in a password not complex enough and press 'Save changes'
      Then I should see 'Password must be at least 12 characters long' 2 times
    When I fill in a password that was used before and press 'Save changes'
      Then I should see 'You have already used that password, choose a new one' 2 times
    When I fill passwords that do not match and press 'Save changes'
      Then I should see 'Enter a password and password confirmation that are the same' 3 times
    When I fill in correct old and new password and press 'Save changes'
      Then I should be on primary user account details page

  Scenario: Password update process as non primary user
    Given I navigate to a Dashboard page with 'MANAGE_VEHICLES' permission
      Then I want to see my account details
      And I want to change my password
      And I should be on account details update password page
    When I fill in correct old and new password and press 'Save changes'
      Then I should be on non primary user account details page