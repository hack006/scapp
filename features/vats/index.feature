Feature: Show all VATs
  In order to have overview of taxes
  As admin
  I want to show list of VATs

  Scenario: Show listing of VAT
    Given I am logged in
      And I have "admin" role
      And Following VATs exists
        | name      | value     | is_time_limited   | start_of_validity | end_of_validity  |
        | Lower 15  | 15        | false             |                   |                  |
        | Basic 20  | 20        | true              | 1/1/2012 00:00    | 31/12/2015 23:59 |
    When I visit page "/vats"
    Then I should see "heading" containing "VATs"
      And I should see "Lower 15" in the table
      And I should see "Basic 20" in the table

  Scenario: Can not show listing of VATs as coach
    Given I am logged in
      And I have "coach" role
    When I visit page "/vats"
    Then I should see "You don't have required permissions!" message

  Scenario: Can not show listing of VATs as player
    Given I am logged in
      And I have "player" role
    When I visit page "/vats"
    Then I should see "You don't have required permissions!" message