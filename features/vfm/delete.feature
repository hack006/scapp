Feature: Delete existing measurement to which I have required permissions
  In order to clear bad measurement
  As a logged in user
  I want to remove measurements of user that I can access

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

  @javascript
  Scenario: As an owner of measurement I want to delete it
    Given I have "player" role
      And I am at the "/variable_field_measurements" page
    When I click "Delete" for "100" in table row
      And I confirm popup
    Then I should see "Variable field measurement was successfully removed." message

  @javascript
  Scenario: As a coach owning any measurement I want to delete it
    Given I have "coach" role
      And I have "coach" relation with user "test2"
      And I am at the "/variable_field_measurements" page
    When I click "Delete" for "200" in table row
    And I confirm popup
    Then I should see "Variable field measurement was successfully removed." message

  @javascript
  Scenario: As an admin I want to have possibility to delete any measurement
    Given I have "admin" role
      And I am at the "/variable_field_measurements" page
    When I click "Delete" for "200" in table row
      And I confirm popup
    Then I should see "Variable field measurement was successfully removed." message