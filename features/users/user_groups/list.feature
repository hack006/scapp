Feature: Show groups user is assigned in
  In order to have overview of groups I am part of
  As a logged in user
  I want to view groups I am assigned in

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And Following groups exists in the system
        | name        | description         | long desc     | owner       | visibility  |
        | group1      | group1 desc         |               | test1       | owner       |
        | group2      | group2 desc         | group 2 LD    | test2       | members     |
        | group3      | group3 desc         | group 3 LD    | test3       | owner       |
      And User "test2" is in group "group1"
      And User "test3" is in group "group1"
      And User "test3" is in group "group2"

  Scenario: I view groups in which I am assigned in and which are not only :owner visible
    Given I have "player" role
      And User "test1" is in group "group2"
      And User "test1" is in group "group3"
      And I am at the "/users/test1" page
    When I click "Groups user is in"
    Then I should see "heading" containing "User assigned in groups"
      And I should see "group2" in the table
      And I shouldn't see "group3" in the table

  Scenario: I view groups of player I am coach of
    Given I have "coach" role
      And User "test2" is in group "group2"
      And User "test2" is in group "group3"
      And "test1" has "coach" relation with user "test2"
      And I am at the "/users/test2" page
    When I click "Groups user is in"
    Then I should see "heading" containing "User assigned in groups"
      And I should see "group1" in the table
      And I should see "group2" in the table
      And I shouldn't see "group3" in the table

  Scenario: I view groups of player I am watcher of
    Given I have "player" role
      And User "test2" is in group "group2"
      And User "test2" is in group "group3"
      And "test1" has "watcher" relation with user "test2"
      And I am at the "/users/test2" page
    When I click "Groups user is in"
    Then I should see "heading" containing "User assigned in groups"
      And I should see "group1" in the table
      And I should see "group2" in the table
      And I shouldn't see "group3" in the table

  Scenario: As admin I can watch groups of any user
    Given I have "admin" role
      And User "test2" is in group "group2"
      And User "test2" is in group "group3"
      And I am at the "/users/test2" page
    When I click "Groups user is in"
    Then I should see "heading" containing "User assigned in groups"
      And I should see "group1" in the table
      And I should see "group2" in the table
      And I should see "group3" in the table