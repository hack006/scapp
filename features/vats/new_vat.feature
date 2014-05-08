Feature: Add new VAT
  In order to manage VATs
  As admin
  I wan to add new VAT
  
  Scenario: Add new VAT
    Given I am logged in
      And I have "admin" role
    When I visit page "/vats/new"
      And I fill in all necessary VATs fields
        | name      | value     | is_time_limited   | start_of_validity | end_of_validity  |
        | Basic 20  | 20        | true              | 1/1/2012 00:00    | 31/12/2015 23:59 |
      And I click "Create VAT"
    Then I should see "VAT was successfully created." message