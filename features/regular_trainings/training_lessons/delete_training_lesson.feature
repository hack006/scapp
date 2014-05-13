Feature: Remove existing regular training lesson
  In order to keep actual information of training lessons
  As admin or owner
  I want to remove existing training lessons

  Background:
    Given I am logged in
      And Following groups exists in the system
        | name    | description     | long desc       | owner     | visibility  | is_global |
        | group1  | Group1 desc     |                 | test1     | members     | false     |
      And Following regular trainings exist in the system
        | name      | description     | is_public   | for_group | owner   |
        | private   | private desc    | true        | group1    | test1   |
      And Following currencies exist in the system
        | name      | code    | symbol    |
        | Euro      | EUR     | €         |
      And Following VATs exists
        |name   | value | is_time_limited | start_of_validity | end_of_validity |
        | Basic | 21    | false           |                   |                 |
      And Following regular training lessons exist in the system
        | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | mon   | true| true  | 10:00   | 12:00   | private           | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |

  @javascript
  Scenario: As regular training lesson owner I remove training lesson that has no realizations
    Given I have "coach" role
      And I am at the "/regular_trainings/private/training_lessons" page
      And I should see "mon" in the table
    When  I click "Delete" for "mon" in table row
      And I confirm popup
    Then I should see "Regular training lesson was successfully removed." message

  Scenario: As regular training lesson owner I can not remove training lesson that has existing realizations
