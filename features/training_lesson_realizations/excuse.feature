Feature: Excuse from scheduled training lesson
  I order to have possibility let coach know that won't be present
  As player signed to training
  I want to excuse from training

  Background:
    Given I am logged in
    And I have "player" role
    And User test2 exists
    And Following groups exists in the system
      | name    | description     | long desc       | owner     | visibility  | is_global |
      | group1  | Group1 desc     |                 | test2     | members     | false     |
    And User "test1" is in group "group1"
    And User "test2" is in group "group1"
    And Following regular trainings exist in the system
      | name        | description     | is_public   | for_group   | owner   |
      | training1   | private 1 desc  | true        | group1      | test2   |
    And Following currencies exist in the system
      | name      | code    | symbol    |
      | Euro      | EUR     | €         |
    And Following VATs exists
      |name   | value | is_time_limited | start_of_validity | end_of_validity |
      | Basic | 20    | false           |                   |                 |
    And Following regular training lessons exist in the system
      | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
      | mon   | true| true  | 10:00   | 12:00   | training1         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
    And Following regular training lesson realizations exist
      | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
      | training1         | mon   | 10:00 | 12:00 | 5/5/2000  | scheduled | No note               |               |             |
      | training1         | mon   | 10:00 | 12:00 | 19/5/200O | done      | No note               |               |             |
      | training1         | mon   | 10:00 | 12:00 | 12/5/2050 | scheduled | No note               |               |             |

  Scenario: I can not excuse after reaching excuse limit
    Given Following attendance entries exists
      | user      | training_realization              | participation | price_without_tax | note    | excuse_reason   |
      | test1     | training1-5-5-2000-10-00-12-00    | signed        | 10                |         |                 |
      And I am at the "/scheduled_lessons/training1-5-5-2000-10-00-12-00" page
    Then I should see "Excuse" action button
    When I click "Excuse"
    Then I should see "Following errors occurred: You can not excuse! Time limit for excusing has been reached." message

  Scenario: I can not excuse if lesson is closed
    Given Following attendance entries exists
      | user      | training_realization              | participation | price_without_tax | note    | excuse_reason   |
      | test1     | training1-19-5-200-10-00-12-00   | present       | 10                |         |                 |
      And I am at the "/scheduled_lessons/training1-19-5-200-10-00-12-00" page
    Then I should see "Excuse" action button
    When I click "Excuse"
    Then I should see "Following errors occurred: You can not excuse! Training has been already closed. You can not excuse!" message

  Scenario: I can excuse before reaching excuse limit
    Given Following attendance entries exists
      | user      | training_realization              | participation | price_without_tax | note    | excuse_reason   |
      | test1     | training1-12-5-2050-10-00-12-00    | signed        | 10                |         |                 |
      And I am at the "/scheduled_lessons/training1-12-5-2050-10-00-12-00" page
    Then I should see "Excuse" action button
    When I click "Excuse"
    Then I should see "You were successfully excused from scheduled training lesson." message