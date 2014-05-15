Feature: I can edit variable field category
  In order to manage variable field categories
  As admin and VF category owner
  I can edit variable field category
  
  Background: 
    Given I am logged in
      And User test2 exists
      And Following VF categories exist in the system
        | user    | name      | description       | RGB     | is_global     |
        | test1   | vfc1      | vfc1 desc         | 111111  | true          |
        | test1   | vfc2      | vfc2 desc         | 222222  | false         |
        | test2   | vfc3      | vfc3 desc         | 333333  | true          |
        | test2   | vfc4      | vfc4 desc         | 444444  | false         |
    
  Scenario: I can edit my variable field category
    Given I have "player" role
      And I am at the "/variable_field_categories" page
    When I click "Edit" for "vfc1" in table row
    Then I should see "heading" containing "Edit variable field category"
    When I fill in all required VF category details
      | name    | rgb     | description   | is_global | user      |
      | vfc11   | 111111  | vfc11 desc    |           |           |
      And I click "Save changes"
    Then I should see "Variable field category was successfully updated." message
      And I should see "vfc11" in the table
      And I should see "111111" in the table
      And I should see "vfc11 desc" in the table
    
  Scenario: I can not edit variable field category I don't own
    Given I have "player" role
    When I view edit page of "vfc4" vfc
    Then I should see "You don't have required permissions!" message

  Scenario: I can edit any variable field category as admin
    Given I have "admin" role
      And I am at the "/variable_field_categories" page
    When I click "Edit" for "vfc4" in table row
    Then I should see "heading" containing "Edit variable field category"
    When I fill in all required VF category details
      | name    | rgb     | description   | is_global | user      |
      | vfc44   | 444444  | vfc44 desc    |           |           |
      And I click "Save changes"
    Then I should see "Variable field category was successfully updated." message
      And I should see "vfc44" in the table
      And I should see "444444" in the table
      And I should see "vfc44 desc" in the table
    