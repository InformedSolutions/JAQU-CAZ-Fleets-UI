Feature: Password reset
  As a User
  I want to be able to reset my password

  Scenario: Go to forgotten password page
    Given I am on the Sign in page
    Then I press "Forgotten your password?" link
      And I should see "Reset your password"
    When I enter invalid email address
      And I should see "There is a problem"
      And I should see "[TBA] Email address is required, [TBA] Email address is in an invalid format"
    When I enter valid email address
      And I should see "Sign in"
