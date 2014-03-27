Feature: List trainings
  In order to have overview of trainings in the club
  As a registered user
  I want to view listing of trainings I have permission to see

  Background:
    Given I am logged in
      And User test2 exists
      And Following groups exists in the system
        | name    | description       | long desc     | owner       | visibility  | is_global |
        | group1  | group1 desc       |               | test1       | public      | false     |
      And Following regular trainings exist in the system
        | name      | description     | is_public   | for_group | owner   |
        | public1   | public 1 desc   | true        | group1    | test2   |
        | private1  | private 1 desc  | false       | group1    | test2   |


  Scenario: As player I want to see public trainings
    Given I have "player" role
    When I visit page "/regular_trainings"
    Then I should see "public1" in the table
      And I shouldn't see "private1" in the table

  Scenario: As coach I want to see public trainings and trainings owned by me
    Given I have "coach" role
      And Following regular trainings exist in the system
        | name      | description     | is_public   | for_group | owner   |
        | private2  | private 2 desc  | false       | group1    | test1   |
    When I visit page "/regular_trainings"
    Then I should see "public1" in the table
      And I should see "private2" in the table
      And I shouldn't see "private1" in the table

  Scenario: As admin I want to see all trainings
    Given I have "admin" role
    When I visit page "/regular_trainings"
    Then I should see "public1" in the table
      And I should see "private1" in the table
