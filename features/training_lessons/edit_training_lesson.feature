Feature: Edit existing regular training lesson
  In order to keep actual information of training lessons
  As admin or owner
  I want to edit existing training lessons

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

  Scenario: As regular training lesson owner I edit it
    Given I have "coach" role
      And I am at the "/regular_trainings/private/training_lessons" page
      And I should see "mon" in the table
    When  I click "Edit" for "mon" in table row
      And I fill in all necessary training lesson fields
        | day   | odd | even  | from    | until   | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | mon   | true| true  | 11:00   | 13:00   | 25              |                 | Basic         | Euro      | 15              | Basic       | fixed_player_price    |
      And I click "Save changes"
    Then I should see "Regular training lesson was successfully updated." message
      And I should see "11:00" in the date & time table
      And I should see "13:00" in the date & time table
      And I should see "30" in the finance table
      And I should see "36.3" in the finance table
      And I should see "50" in the finance table
      And I should see "60.5" in the finance table
