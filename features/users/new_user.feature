Feature: Admin creates new user
  In order to have possibility to close open registration
  As the admin
  I want to create new users from inside the system

  Scenario: As admin I can create new user
    Given I am logged in
      And I have "admin" role
      And I am at the "/users" page
    When I click New user button
    And I fill in all required user fields
      | name        | email             | locale  |
      | pepa        | pepa@example.com  | English |
    And I click "Create"
    Then I should see "User has been successfully created" message
      And I should see "pepa" in the table

  Scenario: As coach I can not create new user
    Given I am logged in
      And I have "coach" role
      And I am at the "/users" page
    Then I shouldn't see "New user" in actionbox