Feature: Calculate payments for scheduled lesson players
  In order to simplify process of payment calculation for scheduled lesson players
  As admin, scheduled lesson owner, head coach and supplementation coach
  I can run automatic calculation process

  Calculation is dependent on the attendance entries for scheduled lessons. Only present and unexcused players are
  counted to the calculation. Calculation strategy is based on specified calculation method selected for current
  scheduled lesson or regular lesson (for regular trainings).

  Automatically calculated prices can be individually changed. Price balance is shown to inform coach about profitability
  of training. It is based on costs (training lesson rental costs, coach wages) and profit (payments from players).

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And User test4 exists
      And Following groups exists in the system
        | name    | description     | long desc       | owner     | visibility  | is_global |
        | group1  | Group1 desc     |                 | test2     | members     | true      |
      And User "test2" is in group "group1"
      And User "test3" is in group "group1"
      And User "test4" is in group "group1"
      And Following regular trainings exist in the system
        | name        | description     | is_public   | for_group   | owner   |
        | training1   | private 1 desc  | true        | group1      | test1   |
        | training2   | private 1 desc  | true        | group1      | test2   |
      And Following currencies exist in the system
        | name      | code    | symbol    |
        | Euro      | EUR     | €         |
      And Following VATs exists
        |name   | value | is_time_limited | start_of_validity | end_of_validity |
        | Basic | 20    | false           |                   |                 |
      And Following regular training lessons exist in the system
        | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | mon   | true| true  | 10:00   | 12:00   | training1         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
        | mon   | true| true  | 13:00   | 14:00   | training2         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
      And Following regular training lesson realizations exist
        | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
        | training1         | mon   | 10:00 | 12:00 | 5/5/2050  | scheduled | No note               |               |             |
        | training2         | mon   | 13:00 | 14:00 | 5/5/2050  | scheduled | No note               |               |             |
      And Following attendance entries exists
        | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
        | test2     | training1-5-5-2050-10-00-12-00  | present         | 0                   |         |                 |
        | test3     | training1-5-5-2050-10-00-12-00  | excused         | 0                   |         |                 |
        | test4     | training1-5-5-2050-10-00-12-00  | unexcused       | 0                   |         |                 |
        | test2     | training2-5-5-2050-13-00-14-00  | present         | 0                   |         |                 |
        | test3     | training2-5-5-2050-13-00-14-00  | excused         | 0                   |         |                 |
        | test4     | training2-5-5-2050-13-00-14-00  | unexcused       | 0                   |         |                 |

  Scenario: I use default calculated prices
    Given I have "coach" role
      And I am at the "/scheduled_lessons/training1-5-5-2050-10-00-12-00/attendances/calc_payment" page
    Then I should see calculated price without vat "20" for player "test2"
      And I should see calculated price without vat "20" for player "test4"
    When I click "Save calculation"
    Then I should see "New prices were successfully saved." message
      And I should see calculated price without vat "20.0" for player "test2" in registered players table
      And I should see calculated price without vat "0.0" for player "test3" in registered players table
      And I should see calculated price without vat "20.0" for player "test4" in registered players table

  Scenario: I save calculation as head coach
    Given I have "coach" role
      And Following coach obligations exist
        | regular_training  | user    | hourly_wage_wt  | vat   | currency  | coach_role  |
        | training2         | test1   | 10              | basic | euro      | head_coach  |
      And I am at the "/scheduled_lessons/training2-5-5-2050-13-00-14-00/attendances/calc_payment" page
    Then I should see calculated price without vat "20" for player "test2"
      And I should see calculated price without vat "20" for player "test4"
    When I click "Save calculation"
    Then I should see "New prices were successfully saved." message
      And I should see calculated price without vat "20.0" for player "test2" in registered players table
      And I should see calculated price without vat "0.0" for player "test3" in registered players table
      And I should see calculated price without vat "20.0" for player "test4" in registered players table

  Scenario: I save calculation as supplementation coach
    Given I have "coach" role
      And Following present coaches exists
        | training_lesson_realization     | user      | vat     | currency    | salary_without_tax  | supplementation   |
        | training2-5-5-2050-13-00-14-00  | test1     | basic   | euro        | 20                  | true              |
      And I am at the "/scheduled_lessons/training2-5-5-2050-13-00-14-00/attendances/calc_payment" page
    Then I should see calculated price without vat "20" for player "test2"
      And I should see calculated price without vat "20" for player "test4"
    When I click "Save calculation"
    Then I should see "New prices were successfully saved." message
      And I should see calculated price without vat "20.0" for player "test2" in registered players table
      And I should see calculated price without vat "0.0" for player "test3" in registered players table
      And I should see calculated price without vat "20.0" for player "test4" in registered players table


  Scenario: I enhance default price values
    Given I have "coach" role
      And I am at the "/scheduled_lessons/training1-5-5-2050-10-00-12-00/attendances/calc_payment" page
    Then I should see calculated price without vat "20" for player "test2"
      And I should see calculated price without vat "20" for player "test4"
    When I change attendance price without vat for "test4" player to "40" value
      And I click "Save calculation"
    Then I should see "New prices were successfully saved." message
      And I should see calculated price without vat "20.0" for player "test2" in registered players table
      And I should see calculated price without vat "0.0" for player "test3" in registered players table
      And I should see calculated price without vat "40.0" for player "test4" in registered players table

  Scenario: I view alert of lesson in loss
    Given I have "coach" role
      And Following present coaches exists
        | training_lesson_realization     | user      | vat     | currency    | salary_without_tax  | supplementation   |
        | training1-5-5-2050-10-00-12-00  | test2     | basic   | euro        | 100                 | false             |
    When I visit page "/scheduled_lessons/training1-5-5-2050-10-00-12-00/attendances/calc_payment"
    Then I should see "WARNING! Training lesson is not gainful. Calculated lost is: 70" basic alert message

