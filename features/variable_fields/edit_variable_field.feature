Feature: Edit variable field
  As a logged in user
  I want to have possibility to change or correct some details
  so I can edit variable field

  This operation is very dangerous, so it needs extra confirmation from user that he exactly knows what he is doing.
  User can edit only owned variable fields.

  Background:
    Given I am logged in
      And I have "coach" role

  Scenario: Edit so far unused variable for measurements
    Given category "intelligence" exists
      And variable_fields exists
        | variable_field_name    | owner     | category      | is_numeric | higher_is_better  |
        | IQ                     | test1     | intelligence  | true       | true              |
      And I am at the "/variable_fields" page
    When I click "Edit" for "IQ" in table row
    Then I should see "heading" containing "Edit variable field"
    When I edit variable field
      And I send form
    Then I should see "success message" containing "successfully updated"

  Scenario: Edit already used variable for measurements
    Given category "intelligence" exists
    And variable_fields exists
      | variable_field_name    | owner     | category      | is_numeric | higher_is_better  |
      | IQ                     | test1     | intelligence  | true       | true              |
    And variable_field_measurements exists for "IQ" of owner "test1"
      | variable_field_name  |owner   | int_value     | string_value  |
      | IQ                   |test1   | 120           |               |
    And I am at the "/variable_fields" page
    When I click "Edit" for "IQ" in table row
    Then I should see "heading" containing "Edit variable field"
      And I should see "warning message" containing "You are changing variable which is already used"
    When I edit variable field
      And I fill in correct modification confirmation token
      And I send form
    Then I should see "success message" containing "successfully updated"