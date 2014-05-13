Feature: Reopen scheduled lesson
  In order to correct mistakes in closed scheduled lesson
  As admin, scheduled lesson owner or supplementation coach
  I can reopen lesson unless payments are connected to it

  Reopening is permitted only unless this operation si safe. If any payment entry is connected to it, then some
  differences could occur and it is unacceptable! We really do not want to have different prices on the invoice
  and int the backend training lessons listing.

  Background:
    Given I am logged in
    And User test2 exists
    And User test3 exists
    And Following groups exists in the system
      | name    | description     | long desc       | owner     | visibility  | is_global |
      | group1  | Group1 desc     |                 | test1     | members     | false     |
      | group2  | Group2 desc     |                 | test2     | members     | false     |
    And User "test1" is in group "group2"
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
      | Basic | 20    | false           |                   |                 |
    And Following regular training lessons exist in the system
      | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
      | mon   | true| true  | 10:00   | 12:00   | training1         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
    And Following regular training lesson realizations exist
      | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
      | training1         | mon   | 10:00 | 12:00 | 5/5/2014  | done      | No note               | 2:00          | 23:59       |
      | training1         | mon   | 10:00 | 12:00 | 12/5/2014 | done      | No note               | 2:00          | 23:59       |
    And Following regular training lessons exist in the system
      | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
      | thu   | true| true  | 15:00   | 16:00   | training2         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
    And Following regular training lesson realizations exist
      | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
      | training2         | thu   | 15:00 | 16:00 | 1/5/2014  | done      | No note               | 2:00          | 23:59       |
      | training2         | thu   | 15:00 | 16:00 | 8/5/2014  | done      | No note               | 2:00          | 23:59       |

  Scenario: I can not reopen lessson which has existing payment

  Scenario: I can not reopen lesson as unauthorized coach
    Given I have "coach" role
    When I visit page "/scheduled_lessons/training2-1-5-2014-15-00-16-00"
    Then I shouldn't see "REOPEN lesson" in actionbox

  Scenario: I can reopen lesson as training owner if no payments exists
    Given I have "coach" role
      And I am at the "/scheduled_lessons/training1-5-5-2014-10-00-12-00" page
    When I click "REOPEN lesson"
      Then I should see "Scheduled training lesson successfully reopened." message

  Scenario: I can reopen lesson as head coach
    Given I have "coach" role
      And Following training obligations exist
        | user    | hourly_wage_wt  | vat       | currency    | role        | regular_training  |
        | test1   | 15              | basic     | euro        | head_coach  | training2         |
      And I am at the "/scheduled_lessons/training2-1-5-2014-15-00-16-00" page
    When I click "REOPEN lesson"
    Then I should see "Scheduled training lesson successfully reopened." message

  Scenario: I can reopen lesson as supplementation coach
    Given I have "coach" role
      And Following present coaches exists
        | training_lesson_realization     | user    | vat   | currency    | salary_without_tax    |supplementation  |
        | training2-1-5-2014-15-00-16-00  | test1   | basic | euro        | 10                    | true            |
      And I am at the "/scheduled_lessons/training2-1-5-2014-15-00-16-00" page
    When I click "REOPEN lesson"
    Then I should see "Scheduled training lesson successfully reopened." message

  Scenario: I can reopen lesson as admin
    Given I have "admin" role
      And I am at the "/scheduled_lessons/training2-1-5-2014-15-00-16-00" page
    When I click "REOPEN lesson"
    Then I should see "Scheduled training lesson successfully reopened." message
