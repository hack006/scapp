Feature: Sign in to the scheduled training
  In order to participate int the scheduled training lessson
  As player
  I can sign in to the scheduled training lesson

  There are requirements that have to be met to allow user to sign in
    * user must sign before sign in time limit
    * if player limit set then it mustn't be reached
    * if regular training then attendance entry for user must exist (user added by coach, probably with status "invited")

  Background:
    Given I am logged in
      And I have "player" role
      And User test2 exists
      And Following groups exists in the system
        | name    | description     | long desc       | owner     | visibility  | is_global |
        | group1  | Group1 desc     |                 | test2     | members     | false     |
      And User "test1" is in group "group1"
      And User "test2" is in group "group1"
      And Following regular trainings exist in the system
        | name        | description     | is_public   | for_group   | owner   |
        | training1   | private 1 desc  | true        | group1      | test2   |
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
        | training1         | mon   | 10:00 | 12:00 | 5/5/2014  | done      | No note               |               |             |
        | training1         | mon   | 10:00 | 12:00 | 12/5/2050 | scheduled | No note               |               |             |
        | training1         | mon   | 10:00 | 12:00 | 19/5/2014 | canceled  | No note               |               |             |

  Scenario: I can not sign in to already closed scheduled training lesson
    Given Following attendance entries exists
      | user      | training_realization              | participation | price_without_tax | note    | excuse_reason   |
      | test1     | training1-5-5-2014-10-00-12-00    | excused       | 10                |         |                 |
    When I visit page "/scheduled_lessons/training1-5-5-2014-10-00-12-00"
    Then I should see "heading" containing "Scheduled regular training lesson detail"
      And I should see "Sign in" action button
    When I click "Sign in"
    Then I should see "You can not sign in. Scheduled lesson is already closed or sign in time limit has been reached!" message

  Scenario: I can not sign to lesson with already reached player limit
    Given Following individual training lesson realizations exist
      | owner   | date          | from    | until     | calculation         | player_price_wt | group_price_wt    | training_vat    | currency    | rental_price_wt   | rental_vat  | status    | note    | sign_in_time    | excuse_time    | is_open    | player_count_limit  |
      | test2   | 20/5/2050     | 10:00   | 12:00     | fixed_player_price  | 10              |                   | basic           | euro        | 5                 | basic       | scheduled | none    |                 |                | true       | 0                   |
      And I am at the "/users/test1/trainings" page
    Then I should see "20/5/2050" in the open trainings
    When I click "Sign in" for "20/5/2050" in table row
    Then I should see "Following errors occurred: Training player limit has been reached. You can not sign in! Try to contact your coach to add you." message

  Scenario: I can not sign in to lesson with already passed sign in limit
    Given Following individual training lesson realizations exist
      | owner   | date          | from    | until     | calculation         | player_price_wt | group_price_wt    | training_vat    | currency    | rental_price_wt   | rental_vat  | status    | note    | sign_in_time    | excuse_time    | is_open    | player_count_limit  |
      | test2   | 20/5/2010     | 10:00   | 12:00     | fixed_player_price  | 10              |                   | basic           | euro        | 5                 | basic       | scheduled | none    |                 |                | true       | 2                   |
      And Following attendance entries exists
        | user      | training_realization              | participation | price_without_tax | note    | excuse_reason   |
        | test1     | test2-20-5-2010-10-00-12-00       | excused       | 10                |         |                 |
      And I am at the "/scheduled_lessons/test2-20-5-2010-10-00-12-00" page
    When I click "Sign in"
    Then I should see "Scheduled lesson is already closed or sign in time limit has been reached!" message

  Scenario: I can sign in to lesson with free places before reaching sign in limit
    Given Following individual training lesson realizations exist
      | owner   | date          | from    | until     | calculation         | player_price_wt | group_price_wt    | training_vat    | currency    | rental_price_wt   | rental_vat  | status    | note    | sign_in_time    | excuse_time    | is_open    | player_count_limit  |
      | test2   | 20/5/2050     | 10:00   | 12:00     | fixed_player_price  | 10              |                   | basic           | euro        | 5                 | basic       | scheduled | none    |                 |                | true       | 2                   |
    And I am at the "/users/test1/trainings" page
    Then I should see "20/5/2050" in the open trainings
    When I click "Sign in" for "20/5/2050" in table row
    Then I should see "You were successfully signed in scheduled training lesson." message

  Scenario: I can sign in to the regular scheduled lesson I am invited to
    Given Following attendance entries exists
      | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
      | test1     | training1-12-5-2050-10-00-12-00 | invited         | 0                   |         |                 |
      And I am at the "/scheduled_lessons/training1-12-5-2050-10-00-12-00" page
    Then I should see "heading" containing "Scheduled regular training lesson detail"
    When I click "Sign in"
    Then I should see "You were successfully signed in scheduled training lesson." message
      And I should see "signed" for "test1" in the table row