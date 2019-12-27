Feature: Vehicles
  In pay for a fleet
  As a user
  I want to add manually vehicles to my fleet

  Scenario: Adding vehicle manually to fleet
    When I visit the enter details page
      And I enter vrn
      And I press the Continue
    Then I should be on the confirm details page
    
  Scenario: Submitting empty vrn
    When I visit the enter details page
      And I press the Continue
    Then I should see "[TBA] The registration number of the vehicle is required" twice
