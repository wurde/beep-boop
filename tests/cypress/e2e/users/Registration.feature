Feature: User Registration

  As a new user
  I want to register with my email
  so that I can have my personal account

  # Scenario: Successful registration
  #   Given I am on the registration page
  #   When I enter a valid email, password, and agree to terms and conditions
  #   And I click on the "Register" button
  #   Then I should see a confirmation message

  Scenario: Registration with already used email
    Given I am on the registration page
    And there is already a user registered with "usedemail@example.com"
    When I try to register with "usedemail@example.com"
    And I click on the "Register" button
    Then I should see an error message that the email is already used
