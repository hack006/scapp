Feature: List regular training lesson realizations
  In order to have overview of past and future regular training lesson realizations
  As admin, training owner, coach, player and watcher of player
  I want can see lesson realizations

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And Following groups exists in the system
        | name    | description     | long desc       | owner     | visibility  | is_global |
        | group1  | Group1 desc     |                 | test1     | members     | false     |
        | group2  | Group2 desc     |                 | test2     | members     | false     |
      And User "test2" is in group "group2"
      And User "test3" is in group "group2"
      And Following regular trainings exist in the system
        | name        | description     | is_public   | for_group   | owner   |
        | training1   | private 1 desc  | false       | group1      | test1   |
        | training2   | private 2 desc  | false       | group2      | test2   |
      And Following currencies exist in the system
        | name      | code    | symbol    |
        | Euro      | EUR     | €         |
      And Following VATs exists
        |name   | value | is_time_limited | start_of_validity | end_of_validity |
        | Basic | 21    | false           |                   |                 |
      And Following regular training lessons exist in the system
        | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | mon   | true| true  | 10:00   | 12:00   | training1         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
      And Following regular training lesson realizations exist
        | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
        | training1         | mon   | 10:00 | 12:00 | 5/5/2014  | done      | No note               | 2:00          | 23:59       |
        | training1         | mon   | 10:00 | 12:00 | 12/5/2014 | scheduled | No note               | 2:00          | 23:59       |
      And Following regular training lessons exist in the system
        | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | thu   | true| true  | 15:00   | 16:00   | training2         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
      And Following regular training lesson realizations exist
        | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
        | training2         | thu   | 15:00 | 16:00 | 1/5/2014  | done      | No note               | 2:00          | 23:59       |
        | training2         | thu   | 15:00 | 16:00 | 8/5/2014  | scheduled | No note               | 2:00          | 23:59       |

  Scenario: I can not see regular training lessons without having specified permissions
    Given I have "coach" role
    When I visit page "/regular_trainings/training2/training_lessons"
    Then I should see "You don't have required permissions!" message
    
  Scenario: I can list training lessons as player of regular training
      Given I have "player" role
        And User "test1" is in group "group2"
      When I visit page "/regular_trainings/training2"
      Then I should see "heading" containing "Regular training detail - training2"
      When I click "List training lessons"
      Then I should see "thu" in the table
        And I shouldn't see "mon" in the table

  Scenario: I can see regular training lessons as training player watcher
    Given I have "watcher" role
      And "test1" has "accepted" "watcher" relation with "test3"
    When I visit page "/regular_trainings/training2"
    Then I should see "heading" containing "Regular training detail - training2"
    When I click "List training lessons"
    Then I should see "thu" in the table
      And I shouldn't see "mon" in the table


  Scenario: I can list training lessons as coach of regular training
    Given I have "coach" role
      And Following training obligations exist
        | user    | hourly_wage_wt  | vat   | currency  | role      | regular_training  |
        | test1   | 10              | basic | euro      | coach     | training2         |
    When I visit page "/regular_trainings/training2"
    Then I should see "heading" containing "Regular training detail - training2"
    When I click "List training lessons"
    Then I should see "thu" in the table
    And I shouldn't see "mon" in the table

  Scenario: I can list training lessons as training lesson owner
    Given I have "coach" role
    When I visit page "/regular_trainings/training1"
    Then I should see "heading" containing "Regular training detail - training1"
    When I click "List training lessons"
    Then I should see "mon" in the table
      And I shouldn't see "thu" in the table

  Scenario: I can list training lessons as administrator
    Given I have "admin" role
    When I visit page "/regular_trainings/training2"
    Then I should see "heading" containing "Regular training detail - training2"
    When I click "List training lessons"
    Then I should see "thu" in the table
      And I shouldn't see "mon" in the table