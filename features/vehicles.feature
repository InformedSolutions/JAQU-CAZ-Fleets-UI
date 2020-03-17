Feature: Vehicles
  In order to pay for a fleet
  As a user
  I want to add manually vehicles to my fleet

  Scenario: Adding vehicle manually to fleet
    When I visit the enter details page
      And I enter vrn
      And I press the Continue
    Then I should be on the details page
    When I choose that the details are correct
      And I press the Confirm
    Then I should be on the manage vehicles page

  Scenario: Submitting empty vrn
    When I visit the enter details page
      And I press the Continue
    Then I should see "Enter the number plate of the vehicle" 3 times

  Scenario: Adding the exempt vehicle
    When I visit the enter details page
      And I enter exempt vrn
      And I press the Continue
    Then I should be on the exempt page
    When I press the Continue to add vehicle
    Then I should be on the manage vehicles page

  Scenario: Adding the not found vehicle
    When I visit the enter details page
      And I enter not found vrn
      And I press the Continue
    Then I should be on the vehicle not found page

  Scenario: Adding a vehicle with incorrect details
    When I visit the enter details page
      And I enter vrn
      And I press the Continue
      And I choose that the details are incorrect
      And I press the Confirm
    Then I should be on the incorrect details page

  Scenario: No selected answer on the details page
    When I visit the enter details page
      And I enter vrn
      And I press the Continue
      And I press the Confirm
    Then I should be on the details page
      And I should see "You must choose an answer" 2 times

