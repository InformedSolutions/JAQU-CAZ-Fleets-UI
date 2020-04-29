Feature: Debits
  In order to pay the charge
  As a user
  I want to manage my Direct Debits mandates

  Scenario: Making a Direct Debit payment with active mandate
    When I have active mandates for selected CAZ
      And I visit the make payment page
      And I press the Continue
    Then I select 'Birmingham'
      And I press the Continue
    Then I click Next 7 days tab
      And I select any date for vrn on the payment matrix
      And I press the Continue
    Then I want to confirm my payment
      And I press the Continue
    Then I select 'Direct Debit'
      And I press the Continue
    Then I should see 'Confirm your payment'
      And I press 'Confirm payment' button
    Then I should see success message

  Scenario: Visiting the manage Direct Debit page with no mandates
    When I have no mandates
      And I visit the manage Direct Debit page
    Then I should be on the add new mandate page

  Scenario: Visiting the manage Direct Debit page with mandates
    When I have created mandates
      And I visit the manage Direct Debit page
    Then I should be on the manage debits page
      And I should see 'Set up new Direct Debit' link
      And I should not see 'You have created a mandate for each CAZ'
    Then I press `Set up new Direct Debit` button
      And I should see 'Which Clean Air Zone do you need to set up a Direct Debit with?'

  Scenario: Visiting the manage Direct Debit page with all mandates
    When I have created all the possible mandates
      And I visit the manage Direct Debit page
    Then I should be on the manage debits page
      And I should not see 'Set up new Direct Debit' link
      And I should see 'You have created a mandate for each CAZ'

  Scenario: Adding a new mandate
    When I have no mandates
      And I visit the add new mandate page
      And I press the Continue
      And I should see 'You must choose one Clean Air Zone' 2 times
    When I select 'Birmingham'
    Then I should have a new mandate added
