Feature: Create variable field category
  In order to manage variable field categories in the system
  As player, coach and admin
  I can add new variable field category

  Background:
    Given I am logged in

  Scenario: I can add private variable field category as player
    Given I have "player" role
      And I am at the "/variable_field_categories" page
    When I click "New"
    Then I should see "heading" containing "New variable field category"
    When I fill in all required VF category details
      | name    | rgb     | description   | is_global | user      |
      | vfc1    | 123456  | vfc1 desc     |           |           |
      And I click "Create VF category"
    Then I should see "Variable field category was successfully created." message
      And I should see "vfc1" in the table
      And I should see "123456" in the table
      And I should see "vfc1 desc" in the table
      And I should see "test1" in the table

  Scenario: I can add private variable field category as coach
    Given I have "coach" role
      And I am at the "/variable_field_categories" page
    When I click "New"
    Then I should see "heading" containing "New variable field category"
    When I fill in all required VF category details
      | name    | rgb     | description   | is_global | user      |
      | vfc1    | 123456  | vfc1 desc     |           |           |
      And I click "Create VF category"
    Then I should see "Variable field category was successfully created." message
      And I should see "vfc1" in the table
      And I should see "123456" in the table
      And I should see "vfc1 desc" in the table
      And I should see "test1" in the table

  Scenario: I can add global variable field category and set ownership to any user in the system
    Given I have "admin" role
      And User test2 exists
      And I am at the "/variable_field_categories" page
    When I click "New"
    Then I should see "heading" containing "New variable field category"
    When I fill in all required VF category details
      | name    | rgb     | description   | is_global | user      |
      | vfc1    | 123456  | vfc1 desc     | true      | test2     |
      And I click "Create VF category"
    Then I should see "Variable field category was successfully created." message
      And I should see "vfc1" in the table
      And I should see "123456" in the table
      And I should see "vfc1 desc" in the table
      And I should see "✓" in the table
      And I should see "test2" in the table