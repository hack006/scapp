Feature: Add new measurement for VF I have access to
  In order to track user progress
  As a logged in user
  I want to add new measurements to user I can access

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
        | IQ1     | 100       |             | Prague    | 2012/01/20 15:00  | test2       |             |

  Scenario: As a player I can add measurement to myself
    Given I have "player" role
      And I am at the "/variable_fields" page
    When I click "Add measurement" for "IQ1" in table row
      And I fill all required fields for variable field measurement for :player
      And I click button "Create Variable field measurement"
    Then I should see "Variable field measurement was successfully created." message

  Scenario: As a coach I can add measurement to my player
    Given I have "coach" role
      And I have "coach" relation with user "test2"
      And I am at the "/variable_fields" page
    When I click "Add measurement" for "IQ1" in table row
      And I fill all required fields for variable field measurement for :player
      And I set measurement_for to user test2
      And I click button "Create Variable field measurement"
    Then I should see "Variable field measurement was successfully created." message

  Scenario: As an admin I can add measurement to any user
    Given I have "admin" role
      And I am at the "/variable_fields" page
    When I click "Add measurement" for "IQ1" in table row
      And I fill all required fields for variable field measurement for :player
      And I set measurement_for to user test2
    And I click button "Create Variable field measurement"
    Then I should see "Variable field measurement was successfully created." message
    