Feature: Remove vehicles
  As a user
  I want to remove vehicles from the list

  Scenario: Remove single vehicle
    When I visit the edit vehicles page
      And I choose 'Remove vehicles'
      And I press 'Continue' button
    Then I should be on remove vehicles page
      And I should see 'Select vehicles to remove' title
    When I select one vrn
      And I press 'Continue' button
    Then I should be on confirm remove vehicle page
      And I should see 'Remove CAZ101?' title
    When I press 'Continue' button
    Then I should be on confirm remove vehicle page
      And I should see 'You must choose an answer'
      And I select 'Yes'
    When I press 'Continue' button
    Then I should be on the manage vehicles page
      And I should see 'You have successfully removed CAZ101 from your vehicle list.'

  Scenario: Remove multiple vehicles
    When I visit the edit vehicles page
      And I choose 'Remove vehicles'
      And I press 'Continue' button
    Then I should be on remove vehicles page
      And I select two vrns
      And I press 'Continue' button
    Then I should be on confirm remove vehicles page
      And I should see 'Remove vehicles from your list?' title
    When I press 'View details' link
    Then I should be on vehicles to remove page
      And I should see 'Vehicles to remove' title
    When I press 'Return to confirmation' link
    Then I should be on confirm remove vehicles page
      And I press 'Remove' link
    Then I should be on the manage vehicles page
      And I should see 'You have successfully removed 2 vehicles from your vehicle list.'

  Scenario: Remove last vehicle in fleet
    When I visit the edit vehicles page with last vehicle
      And I choose 'Remove vehicles'
      And I press 'Continue' button
    Then I should be on remove vehicles page
    When I select one vrn
      And I press 'Continue' button
    Then I should be on confirm remove vehicle page
      And I select 'Yes'
    When I press Continue button and delete my last vehicle in fleet
    Then I should be on the Dashboard page
      And I should see 'You have successfully removed CAZ101 from your vehicle list.'

  Scenario: Remove last vehicles in fleet
    When I visit the edit vehicles page
      And I choose 'Remove vehicles'
      And I press 'Continue' button
    Then I should be on remove vehicles page
      And I select two vrns
      And I press 'Continue' button
    Then I should be on confirm remove vehicles page
    When I press 'View details' link
    Then I should be on vehicles to remove page
    When I press 'Return to confirmation' link
    Then I should be on confirm remove vehicles page
    When I press Remove button and delete my last vehicle in fleet
    Then I should be on the Dashboard page
      And I should see 'You have successfully removed 2 vehicles from your vehicle list.'
