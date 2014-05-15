Feature: Change user role
  In order to assign different role based permissions to users
  As admin
  I can change roles of user

  Multiple roles can selected. It is obvious that user can be both player and coach. Some function blocks are displayed
  based only on the roles that user has. Removing all roles is very dangerous because user won't be able to see majority
  of functions!!

  Background:
    Given I am logged in
      And Global role "watcher" exist in the system
      And Global role "player" exist in the system
      And Global role "coach" exist in the system
      And Global role "admin" exist in the system
      And User test2 exists
      And User test3 exists
      And User "test2" has "player" role

  Scenario: I can change player role to coach role
    Given I have "admin" role
      And I am at the "/users" page
    When I click "Change roles" for "test2" in table row
    Then I should see "heading" containing "Set user roles"
    When I select following roles "coach"
      And I click "Change roles"
    Then I should see "User roles were successfully updated." message
      And I should see "coach" for "test2" in the table row

  Scenario: I can add coach role to user with only player role
    Given I have "admin" role
      And I am at the "/users" page
    When I click "Change roles" for "test2" in table row
    Then I should see "heading" containing "Set user roles"
    When I select following roles "player, coach"
      And I click "Change roles"
    Then I should see "User roles were successfully updated." message
      And I should see "player" for "test2" in the table row
      And I should see "coach" for "test2" in the table row

  Scenario: I can not change role as player
    Given I have "player" role
    And I am at the "/users" page
    And I have "friend" relation with user "test2"
    And I am at the "/users" page
    Then I shouldn't see "Change role" for "test2" in the table row

  Scenario: I can not change role as coach
    Given I have "coach" role
      And I have "friend" relation with user "test2"
      And I am at the "/users" page
    Then I shouldn't see "Change role" for "test2" in the table row