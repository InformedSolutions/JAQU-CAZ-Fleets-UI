Feature: Dashboard
  In order to read the page
  As a user
  I want to manage my users

  Scenario: Visiting the manage users page
    Given I visit the manage users page
    Then I should be on the manage users page
      And I should see 'Add another user'
      And I should see 'Manage' link

  Scenario: Visiting the manage users page with no users
    Given I visit the manage users page with no users
    Then I should be on the manage users page
      And I should see 'Add another user' button
      And I should not see 'Manage' link
      And I should not see 'TBC'

  Scenario: Visiting the manage users page with more then 10 users
    Given I visit the manage users page with more then 10 users
    Then I should be on the manage users page
      And I should not see 'Add another user' button
      And I should see 'TBC'

  Scenario: Visiting the manage users page when i am on the list
    Given I visit the manage users page when i am on the list
    Then I should be on the manage users page
      And I should see 'user@example.com'
      And I should not see 'Manage' link
