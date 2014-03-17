Feature: List variable field measurements
  In order to have overview of measurements
  As a logged in user
  I want to show list of measurements

  Background:
    Given I am logged in
      And User test2 exists
      And following categories are available in the system
        | name    | description             | is_global | user        |
        | C1      | desc1                   | true      |             |
      And Following variable fields exist in system
        | name    | description             | is_global | is_numeric  | category    | user        |
        | IQ1     | intelligence quocient   | true      | true        | C1          |             |
      And Following measurements exists
        | vf_name | int_value | str_value   | locality  | measured_at       | for_user    |
        | IQ1     | 12        |             | Prague    | 2012/01/20 15:00  | test1       |
        | IQ1     | 15        |             | Prague    | 2012/04/20 16:00  | test1       |
        | IQ1     | 100       |             | Prague    | 2012/01/20 15:00  | test2       |

  Scenario: As a :player I can see only my measurements and measurements added to me
    Given I have "player" role
      And I am at the "/variable_field_measurements" page
    Then I should see "integer value" "12" in the table
      And I should see "integer value" "15" in the table
      And I shouldn't see "integer value" "100" in the table

  Scenario: As a :coach I can see only my measurements and measurements of my :players
    Given I have "coach" role
      And I have "coach" relation with user "test2"
      And I am at the "/variable_field_measurements" page
    Then I should see "integer value" "12" in the table
      And I should see "integer value" "15" in the table
      And I should see "integer value" "100" in the table

  Scenario: As an :admin I see all measurements
    Given I have "admin" role
      And I am at the "/variable_field_measurements" page
    Then I should see "integer value" "12" in the table
      And I should see "integer value" "15" in the table
      And I should see "integer value" "100" in the table
