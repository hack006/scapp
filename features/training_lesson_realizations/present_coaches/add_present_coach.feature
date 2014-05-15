Feature: Add scheduled lesson present coach
  In order to have possibility to manage coaches on training
  As admin, training owner and head coach
  I can add present coach to scheduled lesson

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And Following currencies exist in the system
        | name      | code    | symbol    |
        | Euro      | EUR     | €         |
      And Following VATs exists
        |name   | value | is_time_limited | start_of_validity | end_of_validity |
        | Basic | 21    | false           |                   |                 |
      And Following groups exists in the system
        | name    | description     | long desc       | owner     | visibility  | is_global |
        | group1  | Group1 desc     |                 | test1     | members     | true      |
      And User "test2" is in group "group1"
      And User "test3" is in group "group1"
    
      And Following regular trainings exist in the system
        | name        | description     | is_public   | for_group   | owner   |
        | training1   | private 1 desc  | false       | group1      | test1   |
        | training2   | private 2 desc  | false       | group1      | test2   |

      And Following regular training lessons exist in the system
        | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | mon   | true| true  | 10:00   | 12:00   | training1         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
      And Following regular training lesson realizations exist
        | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
        | training1         | mon   | 10:00 | 12:00 | 12/5/2014 | scheduled | No note               | 2:00          | 23:59       |
      And Following present coaches exists
        | training_lesson_realization     | user      | vat     | currency    | salary_without_tax  | supplementation   |
        | training1-12-5-2014-10-00-12-00 | test1     | basic   | euro        | 20                  | false             |

      And Following regular training lessons exist in the system
        | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | thu   | true| true  | 15:00   | 16:00   | training2         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
      And Following coach obligations exist
        | regular_training  | user    | hourly_wage_wt  | vat   | currency  | coach_role  |
        | training2         | test1   | 10              | basic | euro      | head_coach  |
      And Following regular training lesson realizations exist
        | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
        | training2         | thu   | 15:00 | 16:00 | 1/5/2014  | scheduled | No note               | 2:00          | 23:59       |
      And Following present coaches exists
        | training_lesson_realization     | user      | vat     | currency    | salary_without_tax  | supplementation   |
        | training2-1-5-2014-15-00-16-00  | test1     | basic   | euro        | 20                  | true              |

  Scenario: I can add present coach as head coach
    Given I have "coach" role
      And I am at the "/scheduled_lessons/training2-1-5-2014-15-00-16-00" page
    When I click "Add present coach"
    Then I should see "heading" containing "New present coach"
    When I fill all required fields for present coach
      | email                 | salary_wt     | vat     | currency    | supplementation |
      | example2@example.com  | 10            | Basic   | Euro        | false           |
      And I click "Add present coach"
    Then I should see "Present coach was successfully added." message
      And I should see "Show" for "test2" in the table row
      And I should see "Edit" for "test2" in the table row
      And I should see "Delete" for "test2" in the table row


  Scenario: I can add present coach as regular training owner
    Given I have "coach" role
      And I am at the "/scheduled_lessons/training1-12-5-2014-10-00-12-00" page
    When I click "Add present coach"
    Then I should see "heading" containing "New present coach"
    When I fill all required fields for present coach
      | email                 | salary_wt     | vat     | currency    | supplementation |
      | example2@example.com  | 10            | Basic   | Euro        | false           |
      And I click "Add present coach"
    Then I should see "Present coach was successfully added." message
      And I should see "Show" for "test2" in the table row
      And I should see "Edit" for "test2" in the table row
      And I should see "Delete" for "test2" in the table row