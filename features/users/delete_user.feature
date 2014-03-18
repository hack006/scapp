Feature: Remove user
  In order to get rid of unused users
  As admin
  I want to completely remove user from system

  Background:
    Given I am logged in

  @javascript
  Scenario: I remove user
    Given I have "admin" role
      And User test2 exists
      And User test3 exists
      And I am at the "/users" page
    When I click "Delete" for "test2" in table row
      And confirm dialog
      Then I shouldn't see "test2" in the table

  @javascript
  Scenario: As coach I can not remove user
    Given I have "coach" role
      And User test2 exists
      And User test3 exists
      And I have "coach" relation with user "2"
      And I am at the "/users" page
    Then I shouldn't see "Delete" in the table

  @javascript
  Scenario: As player I can not remove user
    Given I have "player" role
      And User test2 exists
      And User test3 exists
      And I have "friend" relation with user "2"
      And I am at the "/users" page
    Then I shouldn't see "Delete" in the table