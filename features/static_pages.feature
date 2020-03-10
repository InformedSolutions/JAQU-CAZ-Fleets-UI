Feature: Static Pages
  In order to read the page
  As a user
  I want to see the static pages

  Scenario: User sees cookies page
    Given I am on the Sign in page
    When I press Cookies link
    Then I should see "Cookies"
      And I should see "A cookie is a small piece of data"

  Scenario: User sees accessibility statement page
    Given I am on the Sign in page
    When I press Accessibility statement link
    Then I should see "Accessibility statement for Pay a Clean Air Zone Charge"