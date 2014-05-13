Feature: Fill attendance of scheduled lesson
  In order to register players attendance
  As Admin, scheduled lesson owner, head coach and supplementation coach
  I can fill attendance

  Attendance entry allows possible 3 states (signed, excused, unexcused). Only players who has signed, present, excused
  or unexcused states are shown. Only invited players are not important. It could only mess list of players.

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


  Scenario: I do not fill all entries
    Given I have "coach" role
      And Following attendance entries exists
        | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
        | test3     | training2-5-5-2050-13-00-14-00  | signed          | 0                   |         |                 |
        | test4     | training2-5-5-2050-13-00-14-00  | signed          | 0                   |         |                 |
      And Following training obligations exist
        | user    | hourly_wage_wt  | vat       | currency    | role              | regular_training  |
        | test1   | 15              | basic     | euro        | head_coach        | training2         |
      And I am at the "/scheduled_lessons/training2-5-5-2050-13-00-14-00" page
    Then I should see "Fill attendance" action button
    When I click "Fill attendance"
      Then I should see "heading" containing "Fill attendance"
      And I shouldn't see "test2" in the table
      And I should see "test3" in the table
      And I should see "test4" in the table
    When I check "present" attendance for "test3" player on "training2-5-5-2050-13-00-14-00" scheduled lesson
      And I click "Save attendance"
    Then I should see "You have not filled all attendance entries!" message

  Scenario: I fill attendance as head coach
    Given I have "coach" role
      And Following attendance entries exists
        | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
        | test2     | training2-5-5-2050-13-00-14-00  | invited         | 0                   |         |                 |
        | test3     | training2-5-5-2050-13-00-14-00  | signed          | 0                   |         |                 |
        | test4     | training2-5-5-2050-13-00-14-00  | signed          | 0                   |         |                 |
      And Following training obligations exist
        | user    | hourly_wage_wt  | vat       | currency    | role              | regular_training  |
        | test1   | 15              | basic     | euro        | head_coach        | training2         |
      And I am at the "/scheduled_lessons/training2-5-5-2050-13-00-14-00" page
    Then I should see "Fill attendance" action button
    When I click "Fill attendance"
    Then I should see "heading" containing "Fill attendance"
      And I shouldn't see "test2" in the table
      And I should see "test3" in the table
      And I should see "test4" in the table
    When I check "present" attendance for "test3" player on "training2-5-5-2050-13-00-14-00" scheduled lesson
      And I check "present" attendance for "test4" player on "training2-5-5-2050-13-00-14-00" scheduled lesson
      And I click "Save attendance"
    Then I should see "Attendance successfully filled." message


  Scenario: I fill attendance as supplementation coach
    Given I have "coach" role
      And Following attendance entries exists
        | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
        | test2     | training2-5-5-2050-13-00-14-00  | invited         | 0                   |         |                 |
        | test3     | training2-5-5-2050-13-00-14-00  | signed          | 0                   |         |                 |
        | test4     | training2-5-5-2050-13-00-14-00  | signed          | 0                   |         |                 |
      And Following present coaches exists
        | training_lesson_realization     | user      | vat     | currency    | salary_without_tax  | supplementation   |
        | training2-5-5-2050-13-00-14-00  | test1     | basic   | euro        | 20                  | true              |
      And I am at the "/scheduled_lessons/training2-5-5-2050-13-00-14-00" page
    Then I should see "Fill attendance" action button
    When I click "Fill attendance"
    Then I should see "heading" containing "Fill attendance"
      And I shouldn't see "test2" in the table
      And I should see "test3" in the table
      And I should see "test4" in the table
    When I check "present" attendance for "test3" player on "training2-5-5-2050-13-00-14-00" scheduled lesson
      And I check "present" attendance for "test4" player on "training2-5-5-2050-13-00-14-00" scheduled lesson
      And I click "Save attendance"
    Then I should see "Attendance successfully filled." message

  Scenario: I fill attendance as owner
    Given I have "coach" role
      And Following attendance entries exists
        | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
        | test2     | training1-5-5-2050-10-00-12-00  | invited         | 0                   |         |                 |
        | test3     | training1-5-5-2050-10-00-12-00  | signed          | 0                   |         |                 |
        | test4     | training1-5-5-2050-10-00-12-00  | signed          | 0                   |         |                 |
      And I am at the "/scheduled_lessons/training1-5-5-2050-10-00-12-00" page
    Then I should see "Fill attendance" action button
    When I click "Fill attendance"
    Then I should see "heading" containing "Fill attendance"
      And I shouldn't see "test2" in the table
      And I should see "test3" in the table
      And I should see "test4" in the table
    When I check "present" attendance for "test3" player on "training1-5-5-2050-10-00-12-00" scheduled lesson
      And I check "present" attendance for "test4" player on "training1-5-5-2050-10-00-12-00" scheduled lesson
      And I click "Save attendance"
    Then I should see "Attendance successfully filled." message
