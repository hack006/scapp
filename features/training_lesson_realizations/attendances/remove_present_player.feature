Feature: Remove present player for the scheduled lesson
  In order to remove players from the scheduled lesson and destroy their attendance
  As admin, training owner, head coach and supplementation coach
  I can remove attendance entry for scheduled lesson

  Background:
    Given I am logged in
    And User test2 exists
    And User test3 exists
    And Following groups exists in the system
      | name    | description     | long desc       | owner     | visibility  | is_global |
      | group1  | Group1 desc     |                 | test1     | members     | true      |
    And User "test2" is in group "group1"
    And User "test3" is in group "group1"
    And Following regular trainings exist in the system
      | name        | description     | is_public   | for_group   | owner   |
      | training1   | private 1 desc  | false       | group1      | test1   |
      | training2   | private 2 desc  | false       | group1      | test2   |
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
    And Following attendance entries exists
      | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
      | test2     | training1-5-5-2014-10-00-12-00  | present         | 10                  |         |                 |
      | test2     | training1-12-5-2014-10-00-12-00 | present         | 10                  |         |                 |

    And Following regular training lessons exist in the system
      | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
      | thu   | true| true  | 15:00   | 16:00   | training2         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
    And Following regular training lesson realizations exist
      | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
      | training2         | thu   | 15:00 | 16:00 | 1/5/2014  | scheduled | No note               | 2:00          | 23:59       |
    And Following attendance entries exists
      | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
      | test2     | training2-1-5-2014-15-00-16-00  | present         | 10                  |         |                 |

  @javascript
  Scenario: As training head coach I can remove attendance entry
    Given I have "coach" role
      And Following coach obligations exist
        | regular_training  | user    | hourly_wage_wt  | vat   | currency  | coach_role  |
        | training2         | test1   | 10              | basic | euro      | head_coach  |
      And I am at the "/scheduled_lessons/training2-1-5-2014-15-00-16-00" page
    When I click "Delete" for "test2" in table row
      And I confirm popup
    Then I should see "Attendance entry was successfully deleted." message
      And I shouldn't see player "test2" in the registered players listing

  @javascript
  Scenario: As training supplementation coach I can remove attendance entry
    Given I have "coach" role
    And Following present coaches exists
      | training_lesson_realization     | user      | vat     | currency    | salary_without_tax  | supplementation   |
      | training2-1-5-2014-15-00-16-00  | test1     | basic   | euro        | 20                  | true              |
    And I am at the "/scheduled_lessons/training2-1-5-2014-15-00-16-00" page
    When I click "Delete" for "test2" in table row
      And I confirm popup
    Then I should see "Attendance entry was successfully deleted." message
    And I shouldn't see player "test2" in the registered players listing

  @javascript
  Scenario: As training owner I can remove attendance entry
    Given I have "coach" role
      And I am at the "/scheduled_lessons/training1-12-5-2014-10-00-12-00" page
    When I click "Delete" for "test2" in table row
      And I confirm popup
    Then I should see "Attendance entry was successfully deleted." message
    And I shouldn't see player "test2" in the registered players listing

  Scenario: Delete player attendance should not be visible for done training lesson
    Given I have "coach" role
    When I am at the "/scheduled_lessons/training1-5-5-2014-10-00-12-00" page
    Then I shouldn't see "link" containing "Delete"