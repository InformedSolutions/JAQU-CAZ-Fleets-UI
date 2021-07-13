Feature: Fleets
  In pay for a fleet
  As a user
  I want to manage my vehicles

  Scenario: Visiting the manage fleet page with empty fleet and use bulk upload
    When I have no vehicles in my fleet and visit the manage vehicles page
      And I should be on the submission method page
    Then I select Bulk upload
      And I press the Continue
    Then I should be on the upload page
      And I should not see 'Results per page'

  Scenario: Visiting the manage fleet page with not empty fleet
    When I have vehicles in my fleet
      And I visit the manage vehicles page
    Then I should see 'Live' 4 times
    Then I should see 'Future' 1 times
    Then I should not see 'FutureCaz'
    Then I should not see 'What does undetermined mean?'
    Then I am able to export my data to CSV file
      And I should see 'Showing 1 to 10 of 15'
      And I should see 'Results per page'

  Scenario: Visiting the manage fleet page with undetermined vehicles in my fleet
    When I have undetermined vehicles in my fleet
      And I visit the manage vehicles page
    Then I should see 'What does undetermined mean?'

  Scenario: No selection on the submission method page
    When I visit the submission method page
      And I press the Continue
    Then I should be on the submission method page
      And I should see 'Choose how to add vehicles to your account'

  Scenario: Manual entry
    When I visit the submission method page
      And I select manual entry
      And I press the Continue
    Then I should be on the enter details page

  Scenario: Fleet add single vehicle
    When I have vehicles in my fleet
      And I visit the manage vehicles page
      And I press 'Edit vehicle list' link
    Then I should see 'Manage Vehicles'
      And I press 'Continue' button
    Then I should see 'You must choose an option'
      And I choose 'Add single vehicle'
      And I press 'Continue' button
    Then I should be on add single vehicle page

  Scenario: Fleet add multiple vehicles
    When I have vehicles in my fleet
      And I visit the manage vehicles page
      And I press 'Edit vehicle list' link
    Then I should see 'Manage Vehicles'
      And I press 'Continue' button
    Then I should see 'You must choose an option'
      And I choose 'Upload a new list'
      And I press 'Continue' button
    Then I should be on the upload page

  Scenario: Backend API is unavailable
    When Fleet backend API is unavailable
      And I visit the manage vehicles page
    Then I should see the Service Unavailable page
      And I should see 'Sorry, the service is unavailable'

  Scenario: Pagination
    When I have vehicles in my fleet
      And I visit the manage vehicles page
    Then I should see active '1' pagination button
      And I should see inactive '2' pagination button
      And I should see inactive 'next' pagination button
      And I should not see 'previous' pagination button
    When I press 2 pagination button
    Then I should see active '2' pagination button
      And I should see inactive '1' pagination button
      And I should see inactive 'previous' pagination button
      And I should not see 'next' pagination button

  Scenario: Empty Search errors
    When I have vehicles in my fleet
      And I visit the manage vehicles page
      And I press 'Search' button
    Then I should see 'Enter the number plate of the vehicle' 2 times

  Scenario: A beta member user visits the Vehicle Management page
    When I have vehicles in my fleet
      And I visit the manage vehicles page as a beta tester
    Then I should see 'Live' 4 times
    Then I should see 'Future' 3 times
    Then I should see 'FutureCaz'

  Scenario: There is more than 3 active Cazes
    When I have vehicles in my fleet and more than 3 CAZes are available
      And I visit the manage vehicles page
    Then I should see 'Add another zone'
      And I should not see 'X' link
    When I press 'Add another zone' link
    Then I should see 'Add another zone'
      And I should see 'X' link 1 times
    When I press 'Add another zone' link
    Then I should not see 'Add another zone'
      And I should see 'X' link 2 times
    When I press 'X' link
    Then I should see 'Add another zone'
      And I should see 'X' link 1 times
    When I press 'X' link
    Then I should see 'Add another zone'
      And I should not see 'X' link
      And I should not see 'Select zone...' link
