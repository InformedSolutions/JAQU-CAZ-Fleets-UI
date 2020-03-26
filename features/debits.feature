Feature: Debits
  In order to pay the charge
  As a user
  I want to manage my direct debits mandates

  Scenario: Making a direct debit payment with vehicles in fleet
    When I have vehicles and want to pay via direct debit
      And I visit the make payment page
      And I press the Continue
    Then I select Birmingham
      And I press the Continue
    Then I click Next 7 days tab
      And I select any date for vrn on the payment matrix
      And I press the Continue
    Then I want to confirm my payment
      And I press the Continue
    Then I select 'Direct Debit'
      And I press the Continue
      And I should see success message

  Scenario: Visiting the manage direct debit page with no mandates
    When I have no mandates
      And I visit the manage direct debit page
    Then I should be on the add new mandate page

  Scenario: Visiting the manage direct debit page with mandates
    When I have created mandates
      And I visit the manage direct debit page
    Then I should be on the manage debits page
      And I should see "Set up new direct debit" link
      And I should not see "You have created a mandate for each CAZ"

  Scenario: Visiting the manage direct debit page with all mandates
    When I have created all the possible mandates
      And I visit the manage direct debit page
    Then I should be on the manage debits page
      And I should not see "Set up new direct debit" link
      And I should see "You have created a mandate for each CAZ"

  Scenario: Adding a new mandate
    When I have no mandates
      And I visit the add new mandate page
      And I press the Continue
      And I should see "Selecting a Clean Air Zone is required" 2 times
    When I select Birmingham
    Then I should have a new mandate added
