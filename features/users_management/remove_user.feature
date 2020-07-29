Feature: Manage user
  In order to read the page
  As a owner
  I want to remove on of my user

  Scenario: Removing a user
    Given I visit the Manage users page and want to remove user
    Then I press 'Change' link
      And I should be on the Manage user page
      And I should see 'Remove' link
    Then I press 'Remove' link
      And I should be on the Delete user page
    Then I press the Continue
      And I should be on the Delete user page
      And I should see 'You must choose an answer' 2 times
    Then I press "Back" link
      And I should be on the Manage user page
    Then I press 'Remove' link
      And I press the Continue
      And I choose 'Yes'
    Then I press the Continue
      And I should be on the Manage users page
      And I should see 'You have successfully removed John Doe from your account.'

  Scenario: Don't wont to remove a user
    Given I visit the Manage users page and do not want to remove user
    Then I press 'Change' link
      And I press 'Remove' link
      And I should be on the Delete user page
      And I choose 'No'
    Then I press the Continue
      And I should be on the Manage user page

