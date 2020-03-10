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
    When I select any date for vrn on the payment matrix
      And I press the Continue
    Then I should be on the confirm payment page
      And I should see the payment details
    When I click view details link
    Then I should be on the Charge details page
    When I press the Back link
      And I press the Continue
    Then I should be on the initiate payment page
