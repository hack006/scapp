Feature: Create individual scheduled training lesson
  In order to provide irregular individual training lessons to players
  As admin or coach
  I can create scheduled individual lesson

  Individual lesson is mainly used for unrepeatable trainings. In contrast to regular training lessons you have to
  configure more options here because no defaults are known. If possible then usage of regular training is preferred.

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And I have "coach" relation with user "test2"
      And I have "coach" relation with user "test3"
      And Following currencies exist in the system
        | name      | code    | symbol    |
        | Euro      | EUR     | €         |
      And Following VATs exists
        |name   | value | is_time_limited | start_of_validity | end_of_validity |
        | Basic | 20    | false           |                   |                 |

  Scenario: I can not create individual training lesson as player
    Given I have "player" role
    When I visit page "/scheduled_lessons/new"
    Then I should see "You don't have required permissions!" message
    
  Scenario: I can create new individual lessons for my players as coach
    Given I have "coach" role
      And I am at the "/users/test1/trainings" page
     When I click "Schedule new lesson"
    Then I should see "heading" containing "New scheduled individual training lesson"
    When I fill all required fields for individual training lesson
      | date      | from  | until   | sign_in_limit   | excuse_limit    | calculation                   | currency  | player_price_without_vat  | group_price_without_vat | training_vat  | rental_price_without_vat  | rental_vat  | can_sign_in | max_players | note             |
      | 12/5/2014 | 8:00  | 10:00   | 12/05/2014 7:00 | 12/05/2014 7:00 | Higher one from FPP and STC   | Euro      | 100                       | 500                     | Basic         | 400                       | Basic       | true        | 10          | Some added note  |
      And I click "Create new individual training lesson"
    Then I should see "Regular training lesson was successfully created." message
      And I should see "scheduled" for "Status" in scheduled lesson details
      And I should see "12/5/2014 7:00" for "Sign in time" in scheduled lesson details
      And I should see "12/5/2014 7:00" for "Excuse time" in scheduled lesson details
      And I should see "100" for "Player price" in scheduled lesson details
      And I should see "120" for "Player price" in scheduled lesson details
      And I should see "500" for "Group price" in scheduled lesson details
      And I should see "600" for "Group price" in scheduled lesson details
      And I should see "400" for "Rental price" in scheduled lesson details
      And I should see "480" for "Rental price" in scheduled lesson details
      And I should see "Higher from FPP and STC" for "Calculation" in scheduled lesson details
      And I should see "✓" for "Is open to public" in scheduled lesson details
      And I should see "10" for "Max. number of players" in scheduled lesson details
      And I should see "Some added note" in training realization note

  Scenario: I can create new individual lesson as admin
    Given I have "admin" role
    And I am at the "/users/test1/trainings" page
    When I click "Schedule new lesson"
    Then I should see "heading" containing "New scheduled individual training lesson"
    When I fill all required fields for individual training lesson
      | date      | from  | until   | sign_in_limit   | excuse_limit    | calculation               | currency  | player_price_without_vat  | group_price_without_vat | training_vat  | rental_price_without_vat  | rental_vat  | can_sign_in | max_players | note             |
      | 12/5/2014 | 8:00  | 10:00   | 12/05/2014 7:00 | 12/05/2014 7:00 | Fixed player price (FPP)  | Euro      | 100                       |                         | Basic         | 400                       | Basic       | false       |             | Some added note  |
    And I click "Create new individual training lesson"
    Then I should see "Regular training lesson was successfully created." message