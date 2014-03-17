Feature: Add measurement to user
  As a logged in user
  I want to add measurements to myself or to users to whom I have coach relation
  So I can registr VF trends in time

  Background:
    Given I am logged in
      And User test2 exists
      And following categories are available in the system
        | name    | description             | is_global | user        |
        | C1      | desc1                   | true      | user2       |
      And Following variable fields exist in system
        | name    | description             | is_global | is_numeric  | category    | user        |
        | IQ1     | intelligence quocient   | true      | true        | C1          |             |
        | IQ2     | intelligence quocient2  | false     | true        | C1          | test1       |

  Scenario: 'As a :player I want to add measurement to myself for VF with existing measurement'
    Given I have "player" role
      And Following measurements exists
        | vf_name | int_value | str_value   | locality  | measured_at       | for_user    |
        | IQ1     | 12        |             | Prague    | 2012/01/20 15:00  | test1       |
      And I am at page listing my variables and measurements
    When I click on "Add new measurement" for VF "IQ1"
    Then I should see "heading" containing "New measurement"
    When I fill in all necessary measurement fields
      And I click button "Add measurement"
    Then I should see "Variable field measurement was successfully created." message

  Scenario: 'As a :coach I want to add measurement to another user to whom I have coach relation'
    Given I have "coach" role
      And I have "coach" relation with user "test2"
      And Following measurements exists
        | vf_name | int_value | str_value   | locality  | measured_at       | for_user    |
        | IQ1     | 12        |             | Prague    | 2012/01/20 15:00  | test2       |
      And I am at page listing user "test2" variables and measurements
    When I click on "Add new measurement" for VF "IQ1"
    Then I should see "heading" containing "New measurement"
    When I fill in all necessary measurement fields
      And I click button "Add measurement"
    Then I should see "Variable field measurement was successfully created." message

  Scenario: 'As a :coach I can not add measurement to another user to whom I have not coach relation'
    Given I have "coach" role
      And Following measurements exists
        | vf_name | int_value | str_value   | locality  | measured_at       | for_user    |
        | IQ1     | 12        |             | Prague    | 2012/01/20 15:00  | test2       |
    And I am at page listing user "test2" variables and measurements
    Then I should see "You don't have required permissions!" message

  Scenario: 'As an :admin I want to add measurement to another user'
    Given I have "admin" role
    And Following measurements exists
      | vf_name | int_value | str_value   | locality  | measured_at       | for_user    |
      | IQ1     | 12        |             | Prague    | 2012/01/20 15:00  | test2       |
    And I am at page listing user "test2" variables and measurements
    When I click on "Add new measurement" for VF "IQ1"
    Then I should see "heading" containing "New measurement"
    When I fill in all necessary measurement fields
    And I click button "Add measurement"
    Then I should see "Variable field measurement was successfully created." message

