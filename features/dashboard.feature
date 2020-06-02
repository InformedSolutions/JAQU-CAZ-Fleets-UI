Feature: Dashboard
  In order to read the page
  As a owner
  I want to see the dashboard page

  Scenario: View dashboard page with fleets
    Given I navigate to a Dashboard page
      And I should see 'Sign in'
    Then I should enter fleet owner credentials and press the Continue
      And I should see 'Manage your vehicles' link
      And I should see 'Make a payment' link
      And I should not see 'You need to upload all your number plates before making a payment.'
      And I should not see 'You need to add at least one more vehicle before making a payment.'
      And I should see 'Your Direct Debits' link

  Scenario: View dashboard page with empty fleets
    Given I navigate to a Dashboard page with empty fleets
      And I should see 'Sign in'
    Then I should enter fleet owner credentials and press the Continue
      And I should see 'Manage your vehicles' link
      And I should not see 'Make a payment' link
      And I should see 'You need to upload all your number plates before making a payment.'
      And I should see 'Set up a Direct Debit' link

  Scenario: View dashboard page with one vehicle in the fleets
    Given I navigate to a Dashboard page with one vehicle in the fleet
      And I should see 'Sign in'
    Then I should enter fleet owner credentials and press the Continue
      And I should see 'Manage your vehicles' link
      And I should not see 'Make a payment' link
      And I should see 'You need to add at least one more vehicle before making a payment.'
      And I should see 'Set up a Direct Debit' link

  Scenario: Owner wants to view dashboard with different IP address
    Given I navigate to a Dashboard page
    Then I should enter fleet owner credentials and press the Continue
      And I should see 'Your account'
    Then I change my IP
      And I navigate to a Dashboard page
    Then I am redirected to the unauthenticated root page
