Feature: Fleets
  In pay for a fleet
  As a user
  I want to manage my vehicles

  Scenario: Visiting the manage fleet page with empty fleet
    When I have no vehicles in my fleet
      And I visit the manage vehicles page
    Then I should be on the submission method page

  Scenario: No selection on the submission method page
    When I visit the the submission method page
      And I press the Continue
    Then I should be on the submission method page
      And I should see "[TBA] Submission method is required"

  Scenario: Manual entry
    When I visit the the submission method page
      And I select manual entry
      And I press the Continue
    Then I should be on the enter details page

  Scenario: CSV Upload
    When I visit the the submission method page
      And I select CSV upload
      And I press the Continue
    Then I should be on the upload page
