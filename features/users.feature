Feature: Users
  In order to read the page
  As an administrator
  I want to manage user accounts

  Scenario: View Manage users page
    Given I am on Dashboard page
    Then I navigate to a Manage users page
      And I should see "Manage your fleet administrators"
    Then I press the Continue
      And I should see "There is a problem"
      And I should see "[TBA] You must choose an answer"
    Then I choose "No"
      And I press the Continue
    Then I should see "Your fleet account"
      And I navigate to a Manage users page
    Then I choose "Yes"
      And I press the Continue
    And I should see "Add users"

    Scenario: Add a fleet administrator
    Given I am on Dashboard page
    Then I navigate to a Manage users page
      And I choose "Yes"
      And I press the Continue
      And I should see "Add users"
    Then I press the Continue
      And I should see "There is a problem"
      And I should see "[TBA] Name is required"
      And I should see "[TBA] Email address is required, [TBA] Email address is in an invalid format"
    Then I should enter valid user details
      And I should see "Manage your fleet administrators"
