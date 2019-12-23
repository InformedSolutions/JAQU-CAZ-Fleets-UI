Feature: Dashboard
  In order to read the page
  As a user
  I want to see the dashboard page

  Scenario: View dashboard page as a user
    Given I am on the root page
      And I should see "Sign in"
    Then I should enter valid credentials and press the Continue
      And I should not see "Manage users" link
      And I should not see "Payment history" link
      And I should see "Manage your vehicles" link
      And I should see "Make a payment" link
      And I should see "Create a direct debit mandate" link

  Scenario: View dashboard page as a admin
    Given I am on the root page
      And I should see "Sign in"
    Then I should enter fleet admin credentials and press the Continue
      And I should see "Manage administrators" link
      And I should see "Payment history" link
      And I should see "Manage your vehicles" link
      And I should see "Make a payment" link
      And I should see "Create a direct debit mandate" link

  Scenario: Admin wants to view dashboard with different IP address
    Given I am on Dashboard page
    Then I should see "Your company account"
    Then I change my IP
      And I navigate to a Dashboard page
    Then I am redirected to the unauthenticated root page
