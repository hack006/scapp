Feature: List registered users
  In order to have overview of users in system
  As a logged in user
  I want to view all users I can access

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And User test4 exists
      And I have "coach" relation with user "test2"
      And I have "friend" relation with user "test3"

  Scenario: I am logged as player and I want to view users I have relation with
    Given I have "player" role
      And I am at the "/users" page
    Then I should see "test2" in the table
      And I should see "test3" in the table
      And I shouldn't see "test4" in the table

  Scenario: I am logged as coach and I want to view users I have relation with
    Given I have "coach" role
      And I am at the "/users" page
    Then I should see "test2" in the table
      And I should see "test3" in the table
      And I shouldn't see "test4" in the table

  Scenario: I am logged as admin and I want to view all users
    Given I have "admin" role
    And I am at the "/users" page
    Then I should see "test2" in the table
      And I should see "test3" in the table
      And I should see "test4" in the table
