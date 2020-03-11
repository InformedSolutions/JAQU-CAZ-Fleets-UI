Feature: Fleets
  In pay for a fleet
  As a user
  I want to pay for my vehicles

  Scenario: Visiting the make a payment page with empty fleet
    When I have no vehicles in my fleet
      And I visit the make payment page
    Then I should be on the first upload page
      And I should see "First upload your vehicles"
    When I press the Continue
      And I should see "Choose how to add vehicles to your account"

  Scenario: Visiting the make a payment page with vehicles in fleet
    When I have vehicles in my fleet
      And I visit the make payment page
    Then I should be on the make a payment page
      And I should see "Which Clean Air Zone do you need to pay for?"
    When I press the Continue
    Then I should see "Selecting a Clean Air Zone is required"
    When I select Birmingham
      And I press the Continue
    Then I should be on the payment matrix page
      And I should see "If you have already paid for a date, it will show as Paid."
    Then I click Next 7 days tab
      And I should see "Check a box for each vehicle and date it drove in a Clean Air Zone."
      And I should see "If you have already paid for a date, it will show as Paid."
    When I select any date for vrn on the payment matrix
      And I press the Continue
    Then I should be on the confirm payment page
      And I should see the payment details
    When I click view details link
    Then I should be on the Charge details page
    When I press the Back link
      And I want to request payments api
      And I press the Continue
    Then I should be on the initiate payment page

  Scenario: Visiting the the matrix page when all dates are unpaid
    When I have vehicles in my fleet that are not paid
      And I visit the make payment page
      And I press the Continue
    Then I select Birmingham
      And I press the Continue
    Then I should be on the payment matrix page
      And I should see "Check a box for each vehicle and date it drove in a Clean Air Zone."
      And I should not see "If you have already paid for a date, it will show as Paid."
    Then I click Next 7 days tab
      And I should see "Check a box for each vehicle and date it will drive in a Clean Air Zone."
      And I should not see "If you have already paid for a date, it will show as Paid."

