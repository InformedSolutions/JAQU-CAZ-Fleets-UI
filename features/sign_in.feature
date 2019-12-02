Feature: Sign In
  In order to read the page
  As a Licensing Authority
  I want to see the upload page

  Scenario: View dashboard page without cookie
    Given I have no authentication cookie
    When I navigate to a Dashboard page
    Then I am redirected to the unauthenticated root page
      And I should see "Sign In"
      And I should not see "Account" link
    Then I should enter valid credentials and press the Continue
    When I should see "Your fleet account"
      And Cookie is created for my session

  Scenario: View dashboard page with cookie that has not expired
    Given I have authentication cookie that has not expired
    When I navigate to a Dashboard page
    Then I should see "Your fleet account"
      And I should see "Account" link

  Scenario: View dashboard page with cookie that has expired
    Given I have authentication cookie that has expired
    When I navigate to a Dashboard page
      And I should not see "Upload" link
    Then I am redirected to the unauthenticated root page
      And I should see "Sign In"

  Scenario: Sign in with invalid credentials
    Given I am on the Sign in page
    When I enter invalid credentials
    Then I remain on the current page
      And I should see "[TBA] The email or password you entered is incorrect"
      And I should see "[TBA] Enter your email address"
      And I should see "[TBA] Enter your password"

  Scenario: Sign out
    Given I am signed in
    When I request to sign out
    Then I am redirected to the Sign in page
    When I navigate to a Dashboard page
    Then I am redirected to the unauthenticated root page
      And I should see "Sign In"

  Scenario: Sign in with invalid email format
    Given I am on the Sign in page
    When I enter invalid email format
    Then I remain on the current page
      And I should see "[TBA] Enter your email address in a valid format"
      And I should see "[TBA] Enter your email address"
