Feature: Delete variable field
  As a logged in user
  I want to delete unused or error variable field
  so I can remove it

  Removing variable field from system is possible only in the case that is not already used.

  Background:
    Given I am logged in
     And I have "coach" role

  @javascript
  Scenario: Remove unused variable field
    Given category "intelligence" exists
      And variable_fields exists
        | variable_field_name    | owner     | category      |
        | IQ                     | test1     | intelligence  |
      And I am at the "/variable_fields" page
    When I click "Delete" for "IQ" in table row
      And confirm dialog
    Then I shouldn't see "IQ" in the table

  @javascript
  Scenario: Remove already used variable
    Given category "intelligence" exists
    And variable_fields exists
      | variable_field_name    | owner     | category      |
      | IQ                     | test1     | intelligence  |
    And variable_field_measurements exists for "IQ" of owner "test1"
      | variable_field_name  |owner   | int_value     |
      | IQ                   |test1   | 120           |
    And I am at the "/variable_fields" page
    When I click "Delete" for "IQ" in table row
    And confirm dialog
    Then I should we warned that measurements exists and variable_field can't be removed

  Scenario: Only owned variable fields can be deleted
    # TODO write scenario