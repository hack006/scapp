Feature: Add new training lesson to existing regular training
  In order to manage regular training lessons
  As admin or regular training owner
  I want to add new training lesson

  Background:
  Given I am logged in
    And I have "coach" role
    And Following groups exists in the system
    | name    | description     | long desc       | owner     | visibility  | is_global |
    | group1  | Group1 desc     |                 | test1     | members     | false     |
    And Following regular trainings exist in the system
    | name      | description     | is_public   | for_group | owner   |
    | private1  | private 1 desc  | false       | group1    | test1   |

  Scenario: As regular training owner I can add new training lesson
    Given I am at the "/regular_trainings/private1" page
      And Following currencies exist in the system
        | name      | code    | symbol    |
        | Euro      | EUR     | €         |
      And Following VATs exists
        |name   | value | is_time_limited | start_of_validity | end_of_validity |
        | Basic | 21    | false           |                   |                 |
    When I click "Add new training lesson"
    Then I should see "heading" containing "New training lesson"
    When I fill in all necessary training lesson fields
      | day   | odd | even  | from    | until   | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
      | mon   | true| true  | 10:00   | 12:00   | 20              |                 | Basic         | Euro      | 10              | Basic       | fixed_player_price    |
      And I click "Create training lesson"
    Then I should see "Regular training lesson was successfully created." message

  Scenario: When no VAT exist then User is redirected to create form
    Given  Following currencies exist in the system
      | name      | code    | symbol    |
      | Euro      | EUR     | €         |
    When I visit page "/regular_trainings/private1/training_lessons/new"
    Then I should see "No VAT exist, yet. You have to add any before adding training lesson." message

  Scenario: When  no currency exist then user is redirected to create form
    Given Following VATs exists
      |name   | value | is_time_limited | start_of_validity | end_of_validity |
      | Basic | 21    | false           |                   |                 |
    When I visit page "/regular_trainings/private1/training_lessons/new"
    Then I should see "No currency exist, yet. You have to add any before adding training lesson." message

  Scenario: Regular training lesson overlapping already existing one can not be added
    Given Following currencies exist in the system
        | name      | code    | symbol    |
        | Euro      | EUR     | €         |
      And Following VATs exists
        |name   | value | is_time_limited | start_of_validity | end_of_validity |
        | Basic | 21    | false           |                   |                 |
      And Following regular training lessons exist in the system
        | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | mon   | true| true  | 10:00   | 12:00   | private1          | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
    And I am at the "/regular_trainings/private1/training_lessons/new" page
    When I fill in all necessary training lesson fields
      | day   | odd | even  | from    | until   | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
      | mon   | true| true  | 11:00   | 13:00   | 20              |                 | Basic         | Euro      | 10              | Basic       | fixed_player_price    |
    And I click "Create training lesson"
    Then I should see "In the specified time interval another training lesson already exist!" message