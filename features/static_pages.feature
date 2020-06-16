Feature: Static Pages
  In order to read the page
  As a user
  I want to see the static pages

  Scenario: User sees cookies page
    Given I am on the Sign in page
    When I press footer link 'Cookies'
    Then I should see "Cookies"
      And I should see "A cookie is a small piece of data"

  Scenario: User sees accessibility statement page
    Given I am on the Sign in page
    When I press footer link 'Accessibility statement'
    Then I should see "Accessibility statement for Drive in a Clean Air Zone"

  Scenario: User sees privacy notice page
    Given I am on the Sign in page
    When I press footer link 'Privacy Notice'
    Then I should see 'Drive in a Clean Air Zone'
