Feature: Fleets
  In pay for a fleet
  As a user
  I want to pay for my vehicles

  Scenario: Visiting the make a payment page with empty fleet
    When I have no vehicles in my fleet
      And I visit the make payment page
    Then I should be on the first upload page
      And I should see 'First upload your vehicles'
    When I press the Continue
      And I should see 'Add vehicles to your account'

  Scenario: Making a card payment with vehicles in fleet
    When I have vehicles in my fleet
      And I visit the make payment page
    Then I should be on the make a payment page
      And I should see 'Which Clean Air Zone do you need to pay for?'
    When I press the Continue
    Then I should see 'You must choose one Clean Air Zone'
    When I select 'Birmingham'
      And I press the Continue
    Then I should be on the payment matrix page
      And I should see 'If you have already paid for a date, it will show as Paid.'
    Then I click Next 7 days tab
      And I should see 'Check a box for each vehicle and date it drove in a Clean Air Zone.'
      And I should see 'If you have already paid for a date, it will show as Paid.'
    When I select any date for vrn on the payment matrix
      And I press the Continue
    Then I should be on the confirm payment page
      And I should see 'Review your payment' title
    When I click view details link
    Then I should be on the Charge details page
    When I press 'Return to review your payment' link
      And I want to confirm my payment
      And I press the Continue
    Then I should be on the Select payment method page
      And I press the Continue
    When I should see 'Choose Direct Debit or Card payment'
      And I select 'Card payment'
      And I press the Continue
    Then I should be on the success payment page
      And I should see success message
    When I click view details link
    Then I should be on the Post Payment Details page
    When I press the Back link
    Then I should be on the success payment page

  Scenario: Making a card payment with vehicles in fleet without any active Direct Debit mandate
    When I have vehicles in my fleet
      And I visit the make payment page
    Then I select 'Birmingham'
      And I press the Continue
    Then I should be on the payment matrix page
    When I select any date for vrn on the payment matrix
      And I press the Continue
    Then I should be on the confirm payment page
      And I want to confirm my payment without any active Direct Debit mandate
      And I press the Continue
    Then I should be on the success payment page
      And I should see success message

  Scenario: Visiting the the matrix page when all dates are unpaid
    When I have vehicles in my fleet that are not paid
      And I visit the make payment page
      And I press the Continue
    Then I select 'Birmingham'
      And I press the Continue
    Then I should be on the payment matrix page
      And I should see 'Check a box for each vehicle and date it drove in a Clean Air Zone.'
      And I should not see 'If you have already paid for a date, it will show as Paid.'
    Then I click Next 7 days tab
      And I should see 'Check a box for each vehicle and date it will drive in a Clean Air Zone.'
      And I should not see 'If you have already paid for a date, it will show as Paid.'
