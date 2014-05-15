Feature: List variable field categories
  In order to have overview of existing variable field categories in the system
  As player, coach and admin
  I can see list of variable field categories

  Only admin can see all variable field categories (VFC). Players and coaches con only see global VFC and owned VFC.

  Background:
    Given I am logged in
      And User test2 exists
      And Following VF categories exist in the system
        | user    | name      | description       | RGB     | is_global     |
        | test1   | vfc1      | vfc1 desc         | 111111  | true          |
        | test1   | vfc2      | vfc2 desc         | 222222  | false         |
        | test2   | vfc3      | vfc3 desc         | 333333  | true          |
        | test2   | vfc4      | vfc4 desc         | 444444  | false         |

  Scenario: As player I can see my and global vfc
    Given I have "player" role
      And I am at the "/variable_field_categories" page
    Then I should see "vfc1" in the table
      And I should see "vfc2" in the table
      And I should see "vfc3" in the table
      And I shouldn't see "vfc4" in the table

  Scenario: As coach I can see my and global vfc
    Given I have "coach" role
    And I am at the "/variable_field_categories" page
    Then I should see "vfc1" in the table
    And I should see "vfc2" in the table
    And I should see "vfc3" in the table
    And I shouldn't see "vfc4" in the table

  Scenario: As admin I can see all vfc
    Given I have "admin" role
    And I am at the "/variable_field_categories" page
    Then I should see "vfc1" in the table
    And I should see "vfc2" in the table
    And I should see "vfc3" in the table
    And I should see "vfc4" in the table

