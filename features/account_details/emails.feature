Feature: Email update
  As an account primary user
  I want to be able to update my email
  So that I can change it for security reasons

  Scenario: Email update process as a primary user
    Given I visit primary user Account Details page
      And I enter change my email page
    Then I should be on account details update email page
    When I press 'Exit without saving' link
      Then I should be on the primary user Account Details page
    When I enter change my email page
      And I fill in email with empty string
      And I press 'Save and continue' button
      Then I should see 'Enter an email address' 2 times
    When I enter change my email page
      And I fill in email with email with invalid format
      And I press 'Save and continue' button
      Then I should see 'Enter an email address in a valid format' 2 times
    When I enter change my email page
      And I fill in email with email with already taken email
      And I press 'Save and continue' button
      Then I should see 'Email address already exists' 2 times
    When I enter change my email page
      And I fill in email with valid email address
      And I press 'Save and continue' button
      Then I should be on the verification email sent page

  Scenario: Changing email address when is logged in
    Given I visit the Confirm email update page
    Then I should see 'Your email address has been updated'
    When I enter only password
      And I press 'Sign in' button
    Then I should see "Confirm your new password" 2 times
    When I enter not matching password and confirmation
      And I press 'Sign in' button
    Then I should see "Enter a password and password confirmation that are the same" 3 times
    When I enter valid password and confirmation
      And I press 'Sign in' button
    Then I should be on the Dashboard page

  Scenario: Changing email address when is not logged in
    Given I visit the Confirm email update page when is not logged in
    When I enter valid password and confirmation
      And I press 'Sign in' button
    Then I should be on the Dashboard page

  Scenario: Changing email address when not enough complex or reused password
    Given I visit the Confirm email update page
    When I enter too easy password and confirmation password
      And I press 'Sign in' button
    Then I should see 'Enter a password at least 12 characters long including at least 1 upper case letter, 1 number and a special character' 2 times
    When I enter reused old password
      And I press 'Sign in' button
    Then I should see 'You have already used that password, choose a new one' 2 times
