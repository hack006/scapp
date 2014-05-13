Feature: View user training attendance
  In order to have overview of trainings I participated in
  As training owner, coach, player and player watcher
  I can see regular training attendance

  This overview shows list of participated lessons including prices. Basic statistics are implemented, too.

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
        | training1         | mon   | 10:00 | 12:00 | 12/5/2014 | done      | No note               | 2:00          | 23:59       |
        | training1         | mon   | 10:00 | 12:00 | 17/5/2014 | scheduled | No note               | 2:00          | 23:59       |
      And Following attendance entries exists
        | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
        | test1     | training1-5-5-2014-10-00-12-00  | present         | 10                  |         |                 |
        | test1     | training1-12-5-2014-10-00-12-00 | present         | 10                  |         |                 |
        | test1     | training1-17-5-2014-10-00-12-00 | signed          | 10                  |         |                 |

        | test2     | training1-5-5-2014-10-00-12-00  | present         | 10                  |         |                 |
        | test2     | training1-12-5-2014-10-00-12-00 | unexcused       | 10                  |         |                 |
        | test2     | training1-17-5-2014-10-00-12-00 | signed          | 10                  |         |                 |


      And Following regular training lessons exist in the system
        | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | thu   | true| true  | 15:00   | 16:00   | training2         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
      And Following regular training lesson realizations exist
        | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
        | training2         | thu   | 15:00 | 16:00 | 1/5/2014  | done      | No note               | 2:00          | 23:59       |
        | training2         | thu   | 15:00 | 16:00 | 8/5/2014  | done      | No note               | 2:00          | 23:59       |
        | training2         | thu   | 15:00 | 16:00 | 15/5/2014 | scheduled | No note               | 2:00          | 23:59       |
      And Following attendance entries exists
        | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
        | test1     | training2-1-5-2014-15-00-16-00  | present         | 10                  |         |                 |
        | test1     | training2-8-5-2014-15-00-16-00  | present         | 10                  |         |                 |
        | test1     | training2-15-5-2014-15-00-16-00 | signed          | 10                  |         |                 |

        | test2     | training2-1-5-2014-15-00-16-00  | present         | 10                  |         |                 |
        | test2     | training2-8-5-2014-15-00-16-00  | excused         | 10                  |         |                 |
        | test2     | training2-15-5-2014-15-00-16-00 | signed          | 10                  |         |                 |

  Scenario: I can view my training attendance
    Given I have "player" role
      And User "test1" is in group "group1"
      And I am at the "/regular_trainings/training2" page
    Then I should see "heading" containing "Regular training detail - training2"
      And I should see "Show my training attendance" action button
    When I click "Show my training attendance"
    Then I should see "heading" containing "User training attendence"
      And I should see "1/5/2014" in the player attendance summary list
      And I should see "8/5/2014" in the player attendance summary list
      And Player attendance statistics should have variable "Present" with containing value "2 (100.0%)"

  Scenario: As training coach I can view
    Given I have "coach" role
      And Following coach obligations exist
        | regular_training  | user    | hourly_wage_wt  | vat   | currency  | coach_role  |
        | training2         | test1   | 10              | basic | euro      | coach  |
      And I am at the "/regular_trainings/training2" page
    Then I should see "heading" containing "Regular training detail - training2"
    When I click "Player attendance" for "test2" in table row
    Then I should see "heading" containing "User training attendence"
      And I should see "1/5/2014" in the player attendance summary list
      And I should see "8/5/2014" in the player attendance summary list
      And Player attendance statistics should have variable "Present" with containing value "1 (50.0%)"
      And Player attendance statistics should have variable "Excused" with containing value "1 (50.0%)"

  Scenario: As training owner I can view player attendance
    Given I have "coach" role
      And I am at the "/regular_trainings/training1" page
    Then I should see "heading" containing "Regular training detail - training1"
    When I click "Player attendance" for "test2" in table row
    Then I should see "heading" containing "User training attendence"
      And I should see "5/5/2014" in the player attendance summary list
      And I should see "12/5/2014" in the player attendance summary list
      And Player attendance statistics should have variable "Present" with containing value "1 (50.0%)"
      And Player attendance statistics should have variable "Unexcused" with containing value "1 (50.0%)"