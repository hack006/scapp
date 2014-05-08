Feature: Edit existing VAT
  In order to manage VATs
  As admin
  I want to edit VAT date ranges

  Scenario: Edit existing VAT
    Given I am logged in
      And I have "admin" role
      And Following VATs exists
        | name      | value     | is_time_limited   | start_of_validity | end_of_validity  |
        | Lower 15  | 15        | false             |                   |                  |
        | Basic 20  | 20        | true              | 1/1/2012 00:00    | 31/12/2015 23:59 |
    When I visit page "/vats"
      And I click "Edit" for "Lower 15" in table row
    And I fill in all fields to change VATs fields
      | is_time_limited   | start_of_validity | end_of_validity  |
      | true              | 1/1/2013 00:00    | 31/12/2014 23:59 |
    And I click "Save changes"
    Then I should see "VAT was successfully updated." message
      And I should see "Lower 15" in the table
      And I shouldn't see "Lower 16" in the table
      And I should see "15" in the table
      And I shouldn't see "16" in the table
      And I should see "1/1/2013 0:00" in the table
      And I should see "31/12/2014 23:59" in the table
