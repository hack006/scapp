Feature: Show variable field category
  In order to have an overview of vfc
  As admin, vfc owner, owner watcher, owner coach, owner player or owner friend
  I can see vfc detail

  Background:
    Given I am logged in
      And User test2 exists
      And Following VF categories exist in the system
        | user    | name      | description       | RGB     | is_global     |
        | test1   | vfc1      | vfc1 desc         | 111111  | true          |
        | test1   | vfc2      | vfc2 desc         | 222222  | false         |
        | test2   | vfc3      | vfc3 desc         | 333333  | true          |
        | test2   | vfc4      | vfc4 desc         | 444444  | false         |

  Scenario: I can not see detail of private vfc if I have no relation to its owner
    Given I have "player" role
    When I view detail page of "vfc4" vfc
    Then I should see "You don't have required permissions!" message

  Scenario: I can see detail of VFC if I have friend relation to VFC owner
    Given I have "player" role
      And I have "friend" relation with user "test2"
    When I view detail page of "vfc4" vfc
    Then I should see "heading" containing "Variable field category"
      And I should see "vfc4" in the table

  Scenario: I can see detail of VFC if I have coach relation to VFC owner
    Given I have "coach" role
      And I have "coach" relation with user "test2"
    When I view detail page of "vfc4" vfc
    Then I should see "heading" containing "Variable field category"
      And I should see "vfc4" in the table

  Scenario: I can see detail of VFC if I have watcher relation to VFC owner
    Given I have "player" role
      And I have "watcher" relation with user "test2"
    When I view detail page of "vfc4" vfc
    Then I should see "heading" containing "Variable field category"
      And I should see "vfc4" in the table

  Scenario: I can see detail of VFC of all VFC as admin
    Given I have "admin" role
    When I view detail page of "vfc4" vfc
    Then I should see "heading" containing "Variable field category"
      And I should see "vfc4" in the table
