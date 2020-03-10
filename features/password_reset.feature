Feature: Password reset
  As a User
  I want to be able to reset my password

  Scenario: Go to forgotten password page
    Given I am on the Sign in page
    Then I press "Forgotten your password?" link
      And I should see "Reset your password"
    When I enter invalid email address
      And I should see "There is a problem"
      And I should see "Email address is required"
    When I enter valid email address
      And I should be on the email sent page

  Scenario: Visit passwords without the token
    Given I visit passwords without the token
    Then I should be on the invalid page
    
  Scenario: Changing password
    Given I visit passwords
    Then I should see "Please enter your new password below"
    When I enter only password
    Then I should see "Password confirmation is required" 2 times
    When I enter not matching password and confirmation
    Then I should see "Password and password confirmation must be the same" 3 times
    When I enter valid password and confirmation
    Then I should be on the success page

  Scenario: Not enough complex password
    Given I visit passwords
    When I enter too easy password and confirmation
    Then I should see "Password must be at least 8 characters long, include at least 1 upper case letter and a number" 2 times
    When I enter valid password and confirmation
    Then I should be on the success page
