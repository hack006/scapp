Feature: Remove variable field category
  In order to manage variable field categories
  As admin and variable field owner
  I can remove variable field category

  Background:
    Given I am logged in
      And User test2 exists
      And Following VF categories exist in the system
        | user    | name      | description       | RGB     | is_global     |
        | test1   | vfc1      | vfc1 desc         | 111111  | true          |
        | test1   | vfc2      | vfc2 desc         | 222222  | false         |
        | test2   | vfc3      | vfc3 desc         | 333333  | true          |
        | test2   | vfc4      | vfc4 desc         | 444444  | false         |

  @javascript
  Scenario: I can remove VF category I own
    Given I have "player" role
      And I am at the "/variable_field_categories" page
    When I click "Delete" for "vfc1" in table row
      And I confirm popup
    Then I should see "Variable field category was successfully removed." message

  @javascript
  Scenario: I can remove any VF category as admin
    Given I have "admin" role
      And I am at the "/variable_field_categories" page
    When I click "Delete" for "vfc4" in table row
      And I confirm popup
    Then I should see "Variable field category was successfully removed." message

  @javascript
  Scenario: VF category which has connected variable field to it can not be removed
    Given I have "coach" role
      And Following variable fields exist in system
        | name  | description | is_global | is_numeric  | category  | user    |
        | vf1   | vf1 desc    | false     | true        | vfc1      | test1   |
      And I am at the "/variable_field_categories" page
    When I click "Delete" for "vfc1" in table row
      And I confirm popup
    Then I should see "Can not be deleted! Dependent variable fields exist for this VF category." message