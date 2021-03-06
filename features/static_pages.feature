Feature: Static Pages
  In order to read the page
  As a user
  I want to see the static pages

  Scenario: User sees cookies page
    Given I am on the Sign in page
    When I press footer link 'Cookies'
    Then I should see 'Cookies' title
      And I should see 'A cookie is a small piece of data'

  Scenario: User sees accessibility statement page
    Given I am on the Sign in page
    When I press footer link 'Accessibility statement'
    Then I should see 'Accessibility statement for Drive in a Clean Air Zone' title

  Scenario: User sees privacy notice page
    Given I am on the Sign in page
    When I press footer link Privacy
    Then I should see 'Privacy Notice' title
      And I should not see 'FutureCaz'

  Scenario: User sees terms and conditions page
    Given I am on the Sign in page
    Then I should see 'Terms and conditions' link
    When I press footer link 'Terms and conditions'
    Then I should see 'Terms and conditions' title

  Scenario: User sees support page
    Given I navigate to a Dashboard page with '' permission
      And I should see 'Support' 3 times
    When I press navbar link Help
    Then I should see 'Support' title
      And I should not see 'FutureCaz'
      And I should see 'Birmingham' 3 times
      And I should see 'Available Now' link

  Scenario: User can access separate cookies path from triage page
    Given I am on the Relevant portal form page
    Then I should see 'Cookies'
    When I press footer link 'Cookies'
    Then I should see 'Cookies are not used in this page.'
