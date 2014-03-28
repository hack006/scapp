Feature: Remove VAT
  In order to manage taxes
  As admin
  I want to have possibility to remove tax

  @javascript
  Scenario: Remove tax
    Given I am logged in
    And I have "admin" role
    And Following VATs exists
      | name      | value     | is_time_limited   | start_of_validity | end_of_validity  |
      | Lower 15  | 15        | false             |                   |                  |
      | Basic 20  | 20        | true              | 1/1/2012 00:00    | 31/12/2015 23:59 |
    When I visit page "/vats"
      And I click "Delete" for "Lower 15" in table row
      And I confirm popup
    Then I should see "VAT was successfully removed." message
      And I shouldn't see "Lower 15" in the table