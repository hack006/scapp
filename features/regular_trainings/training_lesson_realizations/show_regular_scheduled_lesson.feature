Feature: Show detail of regular training lesson realization
  In order to view details and access available realization actions
  As admin, training owner, coach, player and watcher of player
  I want can see lesson realization

  Background:
    Given I am logged in
    And User test2 exists
    And User test3 exists
    And Following groups exists in the system
      | name    | description     | long desc       | owner     | visibility  | is_global |
      | group1  | Group1 desc     |                 | test1     | members     | false     |
      | group2  | Group2 desc     |                 | test2     | members     | false     |
    And User "test2" is in group "group2"
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
      | training2         | thu   | 15:00 | 16:00 | 1/5/2014  | scheduled | No note               | 2:00          | 23:59       |
      | training2         | thu   | 15:00 | 16:00 | 8/5/2014  | scheduled | No note               | 2:00          | 23:59       |
    
  Scenario: I can not see regular training lesson realization detail without required permissions
    Given I have "coach" role
    When I visit page "/scheduled_lessons/training2-1-5-2014-15-00-16-00"
    Then I should see "You don't have required permissions!" message

  Scenario: I can see regular training lesson realization of public training
    Given I have "watcher" role
      And Following regular trainings exist in the system
        | name        | description     | is_public   | for_group   | owner   |
        | training3   | private 3 desc  | true        | group2      | test2   |
      And Following regular training lessons exist in the system
        | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | mon   | true| true  | 10:00   | 12:00   | training3         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
      And Following regular training lesson realizations exist
        | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
        | training3         | mon   | 10:00 | 12:00 | 5/5/2014  | done      | No note               | 2:00          | 23:59       |
      And Following attendance entries exists
        | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
        | test3     | training3-5-5-2014-10-00-12-00  | present         | 10                  |         |                 |
      And Following present coaches exists
        | training_lesson_realization     | user      | vat     | currency    | salary_without_tax  | supplementation   |
        | training3-5-5-2014-10-00-12-00  | test2     | basic   | euro        | 20                  | false             |
      And I am at the "/regular_trainings/training3/scheduled_lessons" page
    When I click "Show" for "5/5/2014" in table row
    Then I should see "heading" containing "Scheduled regular training lesson detail"
      And I should see "test3" in registered players
      And I shouldn't see prices for "test3" in the registered players table
      And I should see "test2" in registered coaches
      And I shouldn't see prices for "test2" in the registered coaches table



  Scenario: I can see regular training lesson realization detail as regular training player with existing attendance entry
    Given I have "player" role
      And User "test1" is in group "group2"
      And I am at the "/regular_trainings/training2/scheduled_lessons" page
    When I click "Show" for "1/5/2014" in table row
    Then I should see "You don't have required permissions!" message
    Given  I am at the "/regular_trainings/training2/scheduled_lessons" page
      And Following attendance entries exists
        | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
        | test1     | training2-1-5-2014-15-00-16-00  | present         | 10                  |         |                 |
        | test3     | training2-1-5-2014-15-00-16-00  | present         | 10                  |         |                 |
      And Following present coaches exists
        | training_lesson_realization     | user      | vat     | currency    | salary_without_tax  | supplementation   |
        | training2-1-5-2014-15-00-16-00  | test2     | basic   | euro        | 20                  | false             |
    When I click "Show" for "1/5/2014" in table row
    Then I should see "heading" containing "Scheduled regular training lesson detail"
      And I should see "test1" in registered players
      And I should see "test3" in registered players
      And I shouldn't see prices for "test3" in the registered players table
      And I should see "test2" in registered coaches
      And I shouldn't see prices for "test2" in the registered coaches table

  Scenario: I can see regular training lesson realization detail as present coach 
    Given I have "coach" role
      And Following present coaches exists
        | training_lesson_realization     | user      | vat     | currency    | salary_without_tax  | supplementation   |
        | training2-1-5-2014-15-00-16-00  | test1     | basic   | euro        | 20                  | false             |
    When I visit page "/regular_trainings/training2/scheduled_lessons"
    Then I should see "You don't have required permissions!" message
    When I visit page "/scheduled_lessons/training2-1-5-2014-15-00-16-00"
    Then I should see "heading" containing "Scheduled regular training lesson detail"
      And I should see "test1" in registered coaches
      And I should see "New measurement" action button


  Scenario: I can see regular training lesson realization detail as coach with obligation to regular training
    Given I have "coach" role
      And Following coach obligations exist
        | regular_training  | user    | hourly_wage_wt  | vat   | currency  | coach_role  |
        | training2         | test1   | 10              | basic | euro      | head_coach  |
      And I am at the "/regular_trainings/training2/scheduled_lessons" page
    When I click "Show" for "1/5/2014" in table row
    Then I should see "heading" containing "Scheduled regular training lesson detail"
      And I should see "Edit training lesson" action button
      And I should see "Fill attendance" action button
      And I should see "CLOSE lesson" action button
      And I should see "CANCEL lesson" action button
      And I should see "New measurement" action button
    
  Scenario: I can see regular training lesson realization detail as admin
    Given I have "admin" role
      And I am at the "/regular_trainings/training2/scheduled_lessons" page
    When I click "Show" for "1/5/2014" in table row
    Then I should see "heading" containing "Scheduled regular training lesson detail"
      And I should see "Edit training lesson" action button
      And I should see "Fill attendance" action button
      And I should see "CLOSE lesson" action button
      And I should see "CANCEL lesson" action button
      And I should see "New measurement" action button