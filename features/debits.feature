Feature: Debits
  In order to pay the charge
  As a user
  I want to manage my direct debits mandates

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

  Scenario: Adding a new mandate without selection
    When I have no mandates
      And I visit the add new mandate page
      And I press the Continue
    Then I should see "[TBA] Selecting a Clean Air Zone is required" twice

  Scenario: Adding a new mandate without selection
    When I have no mandates
      And I visit the add new mandate page
      And I select Birmingham
      And I press the Continue
    Then I should have a new mandate added

