Feature: Uploads
  In order to pay for a fleet
  As a user
  I want to add vehicles to my fleet by submitting CSV file

  Scenario: Uploading file with no vehicles in the fleet
    When I have no vehicles in my fleet
      And I visit the upload page
    Then I should see "Upload your vehicle details"
    When I press upload
    Then I should see "Select a CSV" 2 times
    When I attach a file
      And I press upload
    Then I should be on the processing page
    When I reload the page
    Then I should be on the processing page

  Scenario: Uploading file with vehicles in the fleets
    When I have vehicles in my fleet
      And I visit the upload page
    Then I should see "Upload a new list of vehicles"
    When I attach a file
      And I press upload
    Then I should be on the processing page

  Scenario: Download template
    When I have no vehicles in my fleet
      And I visit the upload page
    Then I should see "Download the CSV" link
    When  I press "Download the CSV" link
    Then I should download the template

  Scenario: Successful upload
    When I am on the processing page
      And My upload is successful
      And I reload the page
    Then I should be on the manage vehicles page

  Scenario: Failed upload
    When I am on the processing page
      And My upload is failed
      And I reload the page
    Then I should see "Upload your vehicle details"
      And I should see "Invalid VRN in line 3"
