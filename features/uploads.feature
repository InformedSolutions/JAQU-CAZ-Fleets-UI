Feature: Uploads
  In order to pay for a fleet
  As a user
  I want to add vehicles to my fleet by submitting CSV file

  Scenario: Uploading file with no vehicles in the fleet
    When I have no vehicles in my fleet
      And I visit the upload page
    Then I should see "Upload your vehicle details"
    When I press upload
    Then I should see "Select a CSV" twice
    When I attach a file
      And I press upload
    Then I should be on the processing page

  Scenario: Uploading file with vehicles in the fleets
    When I have vehicles in my fleet
      And I visit the upload page
    Then I should see "Upload a new list of vehicles"
    When I attach a file
      And I press upload
    Then I should be on the processing page
    When I attach a file
    And I press upload
    Then I should be on the processing page
