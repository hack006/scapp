Feature: Edit currency
  In order to manage more currencies in the system
  As admin
  I can update currency

  Editing currency is available also when any associated objects exist. Only admin can change this and admin is supposed
  to be reliable person.

  Background:
    Given I am logged in
      And Following currencies exist in the system
        | name                | code    | symbol    |
        | Euro                | EUR     | €         |
        | American Dollar     | USD     | $         |
      And Following VATs exists
        |name   | value | is_time_limited | start_of_validity | end_of_validity |
        | Basic | 20    | false           |                   |                 |
      And Following regular trainings exist in the system
        | name        | description     | is_public   | for_group   | owner   |
        | training1   | private 1 desc  | false       | group1      | test1   |
      And Following regular training lessons exist in the system
        | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
        | mon   | true| true  | 10:00   | 12:00   | training1         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |

  Scenario: As admin I can change currency
    Given I have "admin" role
      And I am at the "/currencies" page
    When I click "Edit" for "Euro" in table row
    Then I should see "heading" containing "Edit currency"
    When I fill all required fields for currency
      | name                | code    | symbol    |
      | Euro2               | EUR2    | €2        |
      And I click "Save changes"
    Then I should see "Currency was successfully updated." message
      And I should see "Euro2" in the table
      And I should see "EUR2" in the table
      And I should see "€2" in the table
    
  Scenario: As player I can not modify currency
    Given I have "player" role
    When I visit page "/currencies/euro/edit"
    Then I should see "You don't have required permissions!" message

  Scenario: As coach I can not modify currency
    Given I have "coach" role
    When I visit page "/currencies/euro/edit"
    Then I should see "You don't have required permissions!" message
