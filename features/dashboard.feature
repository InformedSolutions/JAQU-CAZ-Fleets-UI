Feature: Dashboard
  In order to read the page
  As a user
  I want to see the dashboard page

  Scenario: View dashboard page as a user
    Given I am on the root page
      And I should see "Sign in"
    Then I should enter valid credentials and press the Continue
      And I should see "Manage users" link
      And I should see "Payment history" link
      And I should not see "Upload your fleet" link
      And I should not see "Make a payment" link
      And I should not see "Create a direct debit mandate" link

  Scenario: View dashboard page as a fleet admin
    Given I am on the root page
      And I should see "Sign in"
    Then I should enter fleet admin credentials and press the Continue
      And I should see "Manage users" link
      And I should see "Payment history" link
      And I should see "Upload your fleet" link
      And I should see "Make a payment" link
      And I should see "Create a direct debit mandate" link
