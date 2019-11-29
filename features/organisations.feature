Feature: Organisations
  In order to read the page
  As a viewer
  I want to see the email verified page

  Scenario: View email verified page
    Given I am on the home page
    When I go to the email verified page
    Then I should see "Your account has been created"
