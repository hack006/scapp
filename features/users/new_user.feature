Feature: Admin creates new user
  In order to have possibility to close open registration
  As the admin
  I want to create new users from inside the system

  Scenario: As admin I can create new user
    Given I am logged in
      And I have "admin" role
      And I am at the "/users" page
    Then I click "New user""
