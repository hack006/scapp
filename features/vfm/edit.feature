Feature: Edit user variable fields I have access to
  In order to remove mistake in inputted VF measurement
  As a logged in user with required permissions
  I want to edit VF measurement

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
      | IQ1     | 200       |             | Prague    | 2012/01/20 16:00  | test2       | test1       |
    
  Scenario: As an owner I want to edit VF measurement
    Given I have "player" role
      And I am at the "/variable_field_measurements" page
    When I click "Edit" for "100" in table row
    Then I should see "heading" containing "Edit variable field measurement"
    When I change numeric value for variable field measurement to "111"
      And I click button "Save changes"
    Then I should see "Variable field measurement changes were successfully saved." message
      And I should see "111" in the table

  Scenario: As a coach I want to edit VF measurement of my players
    Given I have "coach" role
      And I have "coach" relation with user "test2"
      And I am at the "/variable_field_measurements" page
    When I click "Edit" for "200" in table row
    Then I should see "heading" containing "Edit variable field measurement"
    When I change numeric value for variable field measurement to "222"
      And I click button "Save changes"
    Then I should see "Variable field measurement changes were successfully saved." message
      And I should see "222" in the table

  Scenario: As an admin I want to edit VF measurement of any user
    Given I have "admin" role
      And I am at the "/variable_field_measurements" page
    When I click "Edit" for "200" in table row
    Then I should see "heading" containing "Edit variable field measurement"
    When I change numeric value for variable field measurement to "222"
      And I click button "Save changes"
    Then I should see "Variable field measurement changes were successfully saved." message
      And I should see "222" in the table