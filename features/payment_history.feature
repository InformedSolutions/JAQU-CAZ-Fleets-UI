Feature: Payment History
  In order to read the page
  As a user
  I want to see payment history

  Scenario: User sees company payment history
    Given I visit the Company payment history page
      And I should be on the the Company payment history page
      And I should see 'Royal Mail payment history'
      And I should see 'View details' link
      And I should see active "1" pagination button
      And I should not see "previous" pagination button
    Then I go to the Company payment history page
       And I should see active "1" pagination button
    Then I press 'Back' link
      And I should be on the Dashboard page
    Then I go to the Company payment history page
      And I press 3 pagination button on the payment history page
      And I should be on the Company payment history page number 3
      And I should see active "3" pagination button
    Then I press 5 pagination button on the payment history page
      And I should be on the Company payment history page number 5
      And I should see active "5" pagination button
      And I should not see "next" pagination button
    Then I press 2 pagination button on the payment history page
      And I should be on the Company payment history page number 2
      And I should see active "2" pagination button
      And I should see inactive "1" pagination button
    Then I press 'Back' link
      And I should be on the Company payment history page number 5 when using back button
    Then I press 3 pagination button on the payment history page
      And I should be on the Company payment history page number 3
    Then I press 'Back' link
       And I should be on the Company payment history page number 5 when using back button
    Then I press 'Back' link
      And I should be on the Company payment history page number 3 when using back button
    Then I press 'Back' link
      And I should be on the Company payment history page number 1 when using back button
    Then I press 'Back' link
      And I should be on the Dashboard page

  Scenario: User sees own payment history
    Given I visit the User payment history page
      And I should be on the the User payment history page
      And I should see 'Your payment history'
      And I should see 'View details' link
      And I should see active "1" pagination button
      And I should not see "previous" pagination button
    Then I go to the User payment history page
       And I should see active "1" pagination button
    Then I press 'Back' link
      And I should be on the Dashboard page
    Then I go to the User payment history page
      And I press 3 pagination button on the payment history page
      And I should be on the User payment history page number 3
      And I should see active "3" pagination button
    Then I press 5 pagination button on the payment history page
      And I should be on the User payment history page number 5
      And I should see active "5" pagination button
      And I should not see "next" pagination button
    Then I press 2 pagination button on the payment history page
      And I should be on the User payment history page number 2
      And I should see active "2" pagination button
      And I should see inactive "1" pagination button
    Then I press 'Back' link
      And I should be on the User payment history page number 5 when using back button
    Then I press 3 pagination button on the payment history page
      And I should be on the User payment history page number 3
    Then I press 'Back' link
       And I should be on the User payment history page number 5 when using back button
    Then I press 'Back' link
      And I should be on the User payment history page number 3 when using back button
    Then I press 'Back' link
      And I should be on the User payment history page number 1 when using back button
    Then I press 'Back' link
      And I should be on the Dashboard page

  Scenario: User sees payment details history from Company payments history page
    Given I want visit the Payments details page from Company payments history page
    Then I press 'View details' link
      And I should be on the the Payment details history page
    Then I press 'Cookies' link
      And I should be on the the Cookies page
    Then I press 'Back' link
      And I should be on the the Payment details history page
      And I should see 'Payment made by'
      And I should see 'Print this page'
    Then I press 'Back' link
      And I should be on the the Company payment history page
    Then I press 'View details' link
      And I should be on the the Payment details history page
    Then I press 'Return to payment history' link
      And I should be on the the Company payment history page

  Scenario: User sees payment details history from User payments history page
    Given I want visit the Payments details page from User payments history page
    Then I press 'View details' link
      And I should be on the the Payment details history page
    Then I press 'Cookies' link
      And I should be on the the Cookies page
    Then I press 'Back' link
      And I should be on the the Payment details history page
      And I should not see 'Print this page'
    Then I press 'Back' link
      And I should be on the the User payment history page
    Then I press 'View details' link
      And I should be on the the Payment details history page
    Then I press 'Return to payment history' link
      And I should be on the the User payment history page
