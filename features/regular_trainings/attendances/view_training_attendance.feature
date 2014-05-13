Feature: View regular training attendance overview
  In order to have smart overview of attendance trends and development of attendance trends
  As admin, training owner and training coach
  I can view attendance summary

  Well-arranged table of attendance of players is shown (for better readability paged by 10 pages). Graph of profits
  and costs is added for intuitive representation how training is gainful. Another graph shows barchart of attendance
  participation states combination.

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
  
  Scenario: As training coach I can view training stats
    Given I have "coach" role
      And Following coach obligations exist
        | regular_training  | user    | hourly_wage_wt  | vat   | currency  | coach_role  |
        | training2         | test1   | 10              | basic | euro      | coach  |
      And I am at the "/regular_trainings/training2" page
    When I click "Show attendance"
    Then I should see "heading" containing "Regular training attendance"
      And I should see following training states "present,present" for user "test1"
      And I should see following training states "excused,present" for user "test2"

  Scenario: As training owner I can view training stats
    Given I have "coach" role
      And I am at the "/regular_trainings/training1" page
    When I click "Show attendance"
    Then I should see "heading" containing "Regular training attendance"
      And I should see following training states "present,present" for user "test1"
      And I should see following training states "unexcused,present" for user "test2"