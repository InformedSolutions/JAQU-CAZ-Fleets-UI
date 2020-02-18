Feature: Fleets
  In pay for a fleet
  As a user
  I want to manage my vehicles

  Scenario: Visiting the manage fleet page with empty fleet
    When I have no vehicles in my fleet
      And I visit the manage vehicles page
    Then I should be on the submission method page

  Scenario: No selection on the submission method page
    When I visit the submission method page
      And I press the Continue
    Then I should be on the submission method page
      And I should see "[TBA] Submission method is required"

  Scenario: Manual entry
    When I visit the submission method page
      And I select manual entry
      And I press the Continue
    Then I should be on the enter details page

  Scenario: CSV Upload
    When I have no vehicles in my fleet
      And I visit the submission method page
      And I select CSV upload
      And I press the Continue
    Then I should be on the upload page

  Scenario: Visiting the manage fleet page with vehicles in fleet
    When I have vehicles in my fleet
      And I visit the manage vehicles page
    Then I should be on the manage vehicles page
    Then I press the Continue
    Then I should see "[TBA] You must choose an answer"
    
  Scenario: Removing vehicle from the fleet
    When I have vehicles in my fleet
      And I visit the manage vehicles page
      And I press "Remove" link
    Then I should be on the delete vehicle page
      And I press the Continue
    Then I should see "[TBA] You must choose an answer"
      And I choose "Yes"
      And I press the Continue
    Then I should be on the manage vehicles page
      And I should have deleted the vehicle
    
  Scenario: Backend API is unavailable
    When Fleet backend API is unavailable
      And I visit the manage vehicles page
    Then I should see the Service Unavailable page
      And I should see "Sorry, the service is unavailable"

  Scenario: Pagination
    When I have vehicles in my fleet
      And I visit the manage vehicles page
    Then I should see active "1" pagination button
      And I should see inactive "2" pagination button
      And I should see inactive "next" pagination button
      And I should not see "previous" pagination button
    When I press 2 pagination button
    Then I should see active "2" pagination button
      And I should see inactive "1" pagination button
      And I should see inactive "previous" pagination button
      And I should not see "next" pagination button
