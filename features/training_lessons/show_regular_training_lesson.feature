Feature: View training lesson detail
  In order to get detailed info about training lesson
  As admin, training lesson owner or coach or player, watcher of any permitted user listed previously
  I want to view lesson detail

  Background:
    Given I am logged in
    And User test2 exists
    And User test3 exists
    And Following groups exists in the system
      | name    | description     | long desc       | owner     | visibility  | is_global |
      | group1  | Group1 desc     |                 | test1     | members     | false     |
      | public  | Public group    |                 | test2     | registered  | true      |
      | private | Private group   |                 | test2     | members     | false     |
    And User "test2" is in group "public"
    And User "test3" is in group "public"
    And Following regular trainings exist in the system
      | name      | description     | is_public   | for_group | owner   |
      | public1   | public 1 desc   | true        | public    | test2   |
      | private1  | private 1 desc  | false       | private   | test2   |
      | private2  | private 2 desc  | false       | group1    | test1   |
    And Following currencies exist in the system
      | name      | code    | symbol    |
      | Euro      | EUR     | €         |
    And Following VATs exists
      |name   | value | is_time_limited | start_of_validity | end_of_validity |
      | Basic | 21    | false           |                   |                 |
    And Following regular training lessons exist in the system
      | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
      | mon   | true| true  | 10:00   | 12:00   | private1          | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
      | fri   | true| true  | 15:00   | 16:00   | private1          | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
      | thu   | true| true  | 18:00   | 20:00   | public1           | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
      | mon   | true| true  |  8:00   |  9:00   | private2          | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |

  Scenario: As admin I can see lesson detail of any regular training including finance section
    Given I have "admin" role
    And I am at the "/regular_trainings/private1/training_lessons" page
      When I click "Show" for "mon" in table row
    Then I should see "heading" containing "Training lesson"
      And I should see "heading" containing "Date & Time"
      And I should see "heading" containing "Description"
      And I should see "heading" containing "Finance"

  Scenario: As owner of regular training I can see lesson detail including finance section
    Given I have "coach" role
    And I am at the "/regular_trainings/private2/training_lessons" page
    When I click "Show" for "mon" in table row
    Then I should see "heading" containing "Training lesson"
      And I should see "heading" containing "Date & Time"
      And I should see "heading" containing "Description"
      And I should see "heading" containing "Finance"

  Scenario: As player of regular training I can see lesson detail without finance section
    Given I have "player" role
    And User "test1" is in group "private"
    And I am at the "/regular_trainings/private1/training_lessons" page
    When I click "Show" for "mon" in table row
    Then I should see "heading" containing "Training lesson"
      And I should see "heading" containing "Date & Time"
      And I should see "heading" containing "Description"
      And I shouldn't see "heading" containing "Finance"

  Scenario: As coach with :coach role of regular training lesson I can see lesson detail without finance section
    Given I have "coach" role
    And Following training obligations exist
      | user    | hourly_wage_wt  | vat     | currency    | role      | regular_training  |
      | test1   | 15              | basic   | euro        | coach     | private1          |
    And I am at the "/regular_trainings/private1/training_lessons" page
    When I click "Show" for "mon" in table row
    Then I should see "heading" containing "Training lesson"
      And I should see "heading" containing "Date & Time"
      And I should see "heading" containing "Description"
      And I shouldn't see "heading" containing "Finance"

  Scenario: As coach with :head_coach role of regular training lesson I can see lesson detail with finance section
    Given I have "coach" role
    And Following training obligations exist
      | user    | hourly_wage_wt  | vat     | currency    | role      | regular_training  |
      | test1   | 15              | basic   | euro        | head_coach| private1          |
    And I am at the "/regular_trainings/private1/training_lessons" page
    When I click "Show" for "mon" in table row
    Then I should see "heading" containing "Training lesson"
      And I should see "heading" containing "Date & Time"
      And I should see "heading" containing "Description"
      And I should see "heading" containing "Finance"

  Scenario: As a watcher of player / coach / owner of regular training I can see lesson detail without finance section
    Given I have "player" role
    And Following training obligations exist
      | user    | hourly_wage_wt  | vat     | currency    | role      | regular_training  |
      | test3   | 15              | basic   | euro        | coach     | private1          |
    And I have "watcher" relation with user "test3"
    And I am at the "/regular_trainings/private1/training_lessons" page
    When I click "Show" for "mon" in table row
    Then I should see "heading" containing "Training lesson"
      And I should see "heading" containing "Date & Time"
      And I should see "heading" containing "Description"
      And I shouldn't see "heading" containing "Finance"

  Scenario: As a user (except admin) without any relation to regular training I can not see lessons
    Given I have "player" role
    When I visit page "/regular_trainings/private1/training_lessons"
    Then I should see "You don't have required permissions!" message