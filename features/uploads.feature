Feature: Uploads
  In order to pay for a fleet
  As a user
  I want to add vehicles to my fleet by submitting CSV file

  Scenario: Uploading file with no vehicles in the fleet
    When I have no vehicles in my fleet
      And I visit the upload page
    Then I should see "Upload your vehicle list"
    When I press upload
    Then I should see "Select a file" 2 times
    When I attach a file
      And I press upload
    Then I should be on the processing page
    When I reload the page
    Then I should be on the processing page
      And My upload is successful
      And I reload the page
    Then I should be on the local vehicles exemptions page
      And I press "Continue" link
    Then I should be on the manage vehicles page
      And I should see 'You have successfully uploaded'

  Scenario: Uploading file with vehicles in the fleets
    When I have vehicles in my fleet
      And I visit the upload page
    Then I should see "Replace and upload a new list of vehicles"
    When I attach a file
      And I press upload
    Then I should be on the processing page
      And My upload is successful
      And I reload the page
    Then I should be on the local vehicles exemptions page
      And I press "Continue" link

  Scenario: Download template
    When I have no vehicles in my fleet
      And I visit the upload page
    Then I should see "template" link
    When  I press "template" link
    Then I should download the template

  Scenario: Successful upload
    When I am on the processing page
      And My upload is successful
      And I reload the page
    Then I should be on the local vehicles exemptions page
      And I press "Continue" link
    Then I should be on the manage vehicles page
      And I should see 'You have successfully uploaded'

  Scenario: Failed upload
    When I am on the processing page
      And My upload is failed with error: "Some error message"
      And I reload the page
    Then I should see "Upload your vehicle list"
      And I should see "Some error message"
