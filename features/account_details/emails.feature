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
      And I press 'Save changes' button
      Then I should see 'Enter an email address' 2 times
    When I enter change my email page
      And I fill in email with email with invalid format
      And I press 'Save changes' button
      Then I should see 'Enter an email address in a valid format' 2 times
    When I enter change my email page
      And I fill in email with email with already taken email
      And I press 'Save changes' button
      Then I should see 'Email address already exists' 2 times
    When I enter change my email page
      And I fill in email with valid email address
      And I press 'Save changes' button
      Then I should be on the verification email sent page
