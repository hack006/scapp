Feature: Remove currency
  In order to manage more currencies in the system
  As admin
  I can remove currency

  Background:
    Given I am logged in
      And I have "admin" role
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

  @javascript
  Scenario: I can remove currency which is not already used
    Given I am at the "/currencies" page
    When I click "Delete" for "American Dollar" in table row
      And I confirm popup
    Then I should see "Currency was succesfully removed." message

  @javascript
  Scenario: I can not remove currency which is already used somewhere
    Given I am at the "/currencies" page
    When I click "Delete" for "Euro" in table row
      And I confirm popup
    Then I should see "Can not delete. Currency is already in use!" message