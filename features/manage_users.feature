Feature: Manage users
  In order to read the page
  As a user
  I want to manage my users

  Scenario: Visiting the manage users page
    Given I visit the manage users page
    Then I should be on the manage users page
      And I should see "Add another user"
      And I should see "Manage" link

  Scenario: Visiting the manage users page with no users
    Given I visit the manage users page with no users
    Then I should be on the manage users page
      And I should see "Add another user" button
      And I should not see "Manage" link
      And I should not see "TBC"

  Scenario: Visiting the manage users page with more then 10 users
    Given I visit the manage users page with more then 10 users
    Then I should be on the manage users page
      And I should not see "Add another user" button
      And I should see "TBC"

  Scenario: Visiting the manage users page when i am on the list
    Given I visit the manage users page when i am on the list
    Then I should be on the manage users page
      And I should see "user@example.com"
      And I should not see "Manage" link

  Scenario: Adding new user - nobody added user with the same email in the meantime
    Given I visit the Add user page
    Then I should be on the Add user page
      And I should see "Add a user"
      And I should see "Continue" button
    When I press "Continue" button
    Then I should be on the Add user page
      And I should see "Enter a User name"
      And I should see "Enter a User email"
    When I fill new user form with allready used email
    Then I should be on the Add user page
      And I should see "Email address already exists"
    When I fill new user form with correct data
    Then I should be on the Add user permissions page
    When I press "Back" link
    Then I should be on the Add user page
      And I should see "New User Name" as "new_user_name" value
      And I should see "new_user@example.com" as "new_user_email" value
      And I press "Continue" button
    Then I should be on the Add user permissions page
    When I press "Continue" button and new user email is still unique
    Then I should be on the Add user permissions page
      And I should see "Select at least one permission type to continue"
    When I checked permissions correctly
    Then I should be on the User confirmation page
      And I should not see "Back" link
    When I press "Continue" link
    Then I should be on the manage users page

  Scenario: Adding new user - somebody added user with the same email in the meantime
    Given I visit the Add user page
    Then I should be on the Add user page
      And I should see "Add a user"
      And I should see "Continue" button
    When I fill new user form with correct data
    Then I should be on the Add user permissions page
    When I press "Continue" button and new user with email was added in the meantime
    Then I should be on the Add user page
      And I should see "Email address already exists"
