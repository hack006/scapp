Feature: Edit regular training scheduled lesson
  In order to keep information current and have possibility to correct mistakes
  As training owner, head coach, supplementation coach and admin
  I have possibility to edit scheduled lesson

  In regular training lesson there is no possible to change date and time once it is scheduled. Also training
  lesson state can be changed only directly from training lesson detail. Finally currency is taken from regular
  training lesson so we can not change it, too.

  Background:
    Given I am logged in
    And User test2 exists
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
      | training1         | mon   | 10:00 | 12:00 | 12/5/2014 | scheduled | No note               | 2:00          | 23:59       |
    And Following regular training lessons exist in the system
      | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
      | thu   | true| true  | 15:00   | 16:00   | training2         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
    And Following regular training lesson realizations exist
      | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
      | training2         | thu   | 15:00 | 16:00 | 1/5/2014  | scheduled | No note               | 2:00          | 23:59       |
      | training2         | thu   | 15:00 | 16:00 | 8/5/2014  | scheduled | No note               | 2:00          | 23:59       |

  Scenario: As player I can not edit regular training lesson
    Given I have "player" role
    When I visit page "/scheduled_lessons/training2-1-5-2014-15-00-16-00"
    Then I shouldn't see "Edit training lesson" in actionbox

  Scenario: As regular training owner I can edit it
    Given I have "coach" role
    When I visit page "/scheduled_lessons/training1-12-5-2014-10-00-12-00"
    Then I should see "Edit training lesson" action button
    When I click "Edit training lesson"
    Then I should see "heading" containing "Edit scheduled regular training lesson"
    When I fill all all required fields for regular training lesson realization
        | sign_in_limit   | excuse_limit    | calculation             | player_price_without_vat  | group_price_without_vat | training_vat  | rental_price_without_vat  | rental_vat  | note             |
        | 12/05/2014 8:00 | 12/05/2014 8:00 | Split the costs (STC)   |                           | 500                     | Basic         | 400                       | Basic       | Some added note  |
      And I click "Save changes"
    Then I should see "Scheduled lesson was successfully updated." message
      And I should see "12/5/2014 8:00" for "Sign in time" in scheduled lesson details
      And I should see "12/5/2014 8:00" for "Excuse time" in scheduled lesson details
      And I should see "-" for "Player price" in scheduled lesson details
      And I should see "500" for "Group price" in scheduled lesson details
      And I should see "600" for "Group price" in scheduled lesson details
      And I should see "400" for "Rental price" in scheduled lesson details
      And I should see "480" for "Rental price" in scheduled lesson details
      And I should see "Some added note" in training realization note

  Scenario: I can not edit regular training lessons in which I have only coach role
    Given I have "coach" role
    And Following training obligations exist
      | user    | hourly_wage_wt  | vat       | currency    | role        | regular_training  |
      | test1   | 15              | basic     | euro        | coach       | training2         |
    When I visit page "/scheduled_lessons/training2-8-5-2014-15-00-16-00"
    Then I shouldn't see "Edit training lesson" in actionbox

  Scenario: I can edit regular training lessons in which I have head coach role
    Given I have "coach" role
      And Following training obligations exist
        | user    | hourly_wage_wt  | vat       | currency    | role        | regular_training  |
        | test1   | 15              | basic     | euro        | head_coach  | training2         |
    When I visit page "/scheduled_lessons/training2-8-5-2014-15-00-16-00"
    Then I should see "Edit training lesson" action button
    When I click "Edit training lesson"
    Then I should see "heading" containing "Edit scheduled regular training lesson"
      And I click "Save changes"
    Then I should see "Scheduled lesson was successfully updated." message

  Scenario: As admin I can edit any regular training lesson
    Given I have "admin" role
    When I visit page "/scheduled_lessons/training2-8-5-2014-15-00-16-00"
    Then I should see "Edit training lesson" action button
    When I click "Edit training lesson"
    Then I should see "heading" containing "Edit scheduled regular training lesson"
    And I click "Save changes"
    Then I should see "Scheduled lesson was successfully updated." message

