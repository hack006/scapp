Feature: Show existing measurement to which I have required permissions
  In order have detailed information of measurement
  As a logged in user
  I want to display its detail

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
      | vf_name | int_value | str_value   | locality  | measured_at       | for_user    | measured_by |
      | IQ1     | 100       |             | Prague    | 2012/01/1 15:00   | test1       | test1       |
      | IQ1     | 200       |             | Prague    | 2012/01/20 16:00  | test2       | test2       |

  Scenario: I want to view detail of my owned measurement
    Given I have "player" role
      And I am at the "/variable_field_measurements" page
    When I click "Show" for "100" in table row
    Then I should see "heading" containing "VF measurement detail"
      And I should see "IQ1" in the table
      And I should see "100" in the table

  Scenario: I want to view detail of measurements of my players
    Given I have "coach" role
      And I have "coach" relation with user "test2"
    And I am at the "/variable_field_measurements" page
    When I click "Show" for "200" in table row
    Then I should see "heading" containing "VF measurement detail"
    And I should see "IQ1" in the table
    And I should see "200" in the table

  Scenario: As admin I want to view detail of all measurements
    Given I have "admin" role
      And I am at the "/variable_field_measurements" page
    When I click "Show" for "200" in table row
    Then I should see "heading" containing "VF measurement detail"
      And I should see "IQ1" in the table
      And I should see "200" in the table