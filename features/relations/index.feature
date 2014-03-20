Feature: List all user relations
  In order to have overview of relations in system
  As an admin
  I want to see listing of all user relations

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And "test2" has "friend" relation with user "test3"

  Scenario: Delete relation
    Given I have "admin" role
    When I visit page "/user_relations"
    Then I should see "heading" containing "Listing user relations"
      And I should see "test2" in the table
      And I should see "test3" in the table

  Scenario: Not authorized for player
    Given I have "player" role
    When I visit page "/user_relations"
    Then I should see "You don't have required permissions!" message

  Scenario: Not authorized for coach
    Given I have "coach" role
    When I visit page "/user_relations"
    Then I should see "You don't have required permissions!" message