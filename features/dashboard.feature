Feature: Dashboard
  In order to read the page
  As a admin
  I want to see the dashboard page

  Scenario: View dashboard page with fleets
    Given I navigate to a Dashboard page
      And I should see "Sign in"
    Then I should enter fleet admin credentials and press the Continue
      And I should see "Manage your vehicles" link
      And I should see "Make a payment" link
      And I should not see "You need to upload all your number plates before making a payment."

  Scenario: View dashboard page with empty fleets
    Given I navigate to a Dashboard page with empty fleets
      And I should see "Sign in"
    Then I should enter fleet admin credentials and press the Continue
      And I should see "Manage your vehicles" link
      And I should not see "Make a payment" link
      And I should see "You need to upload all your number plates before making a payment."

  Scenario: Admin wants to view dashboard with different IP address
    Given I navigate to a Dashboard page
    Then I should enter fleet admin credentials and press the Continue
      And I should see "Your account"
    Then I change my IP
      And I navigate to a Dashboard page
    Then I am redirected to the unauthenticated root page
